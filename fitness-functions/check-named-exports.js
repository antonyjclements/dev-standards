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
    if (entry.isDirectory()) return IGNORED_DIRS.has(entry.name) ? [] : walk(fullPath);
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
  const clean = stripComments(fs.readFileSync(file, "utf8"));
  const pattern = /\bexport\s+default\b/g;
  let match;
  while ((match = pattern.exec(clean)) !== null) {
    violations.push({ file, line: lineNumber(clean, match.index) });
  }
}

if (violations.length === 0) {
  console.log("check-named-exports: exports look good.");
  process.exit(0);
}

console.error("check-named-exports: default exports are not allowed.");
console.error("");
for (const violation of violations) {
  console.error(`${relative(violation.file)}:${violation.line} uses export default`);
}
process.exit(1);
