#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const ROOT = process.cwd();
const SRC_DIR = path.join(ROOT, "src");
const EXTENSIONS = new Set([".ts", ".tsx", ".js", ".jsx", ".mts", ".mjs", ".cts", ".cjs"]);
const IGNORED_DIRS = new Set([".git", "node_modules", "dist", "build", "coverage", ".expo", ".next", ".turbo"]);

function walk(dir) {
  if (!fs.existsSync(dir)) return [];
  return fs.readdirSync(dir, { withFileTypes: true }).flatMap((entry) => {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      return IGNORED_DIRS.has(entry.name) ? [] : walk(fullPath);
    }
    return entry.isFile() && EXTENSIONS.has(path.extname(entry.name)) ? [fullPath] : [];
  });
}

function stripComments(source) {
  return source.replace(/\/\*[\s\S]*?\*\//g, "").replace(/(^|[^:])\/\/.*$/gm, "$1");
}

function lineNumber(source, index) {
  return source.slice(0, index).split("\n").length;
}

function relative(file) {
  return file.split(path.sep).join("/").replace(ROOT.split(path.sep).join("/") + "/", "");
}

const violations = [];

for (const file of walk(SRC_DIR)) {
  const source = fs.readFileSync(file, "utf8");
  const clean = stripComments(source);
  const patterns = [
    /\bexport\s+const\s+([A-Za-z_$][\w$]*)\s*(?::[^=]+)?=\s*(?:async\s*)?(?:<[^>\n]+>\s*)?\([^)]*\)\s*=>/g,
    /\bexport\s+const\s+([A-Za-z_$][\w$]*)\s*(?::[^=]+)?=\s*(?:async\s*)?[A-Za-z_$][\w$]*\s*=>/g,
  ];

  for (const pattern of patterns) {
    let match;
    while ((match = pattern.exec(clean)) !== null) {
      violations.push({
        file,
        line: lineNumber(clean, match.index),
        name: match[1],
      });
    }
  }
}

if (violations.length === 0) {
  console.log("check-function-declarations: exported functions look good.");
  process.exit(0);
}

console.error("check-function-declarations: exported top-level functions must use function declarations.");
console.error("");
for (const violation of violations) {
  console.error(`${relative(violation.file)}:${violation.line} exports '${violation.name}' as an arrow function`);
  console.error(`  Use: export function ${violation.name}(...) { ... }`);
}
process.exit(1);
