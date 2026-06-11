#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const ROOT = process.cwd();
const SRC_DIR = path.join(ROOT, "src");
const EXTENSIONS = new Set([".ts", ".tsx", ".mts", ".cts"]);
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
const explicitAny = /\bany\b/g;

for (const file of walk(SRC_DIR)) {
  const clean = stripComments(fs.readFileSync(file, "utf8"));
  let match;
  while ((match = explicitAny.exec(clean)) !== null) {
    violations.push({ file, line: lineNumber(clean, match.index) });
  }
}

if (violations.length === 0) {
  console.log("check-no-any: no explicit any found.");
  process.exit(0);
}

console.error("check-no-any: explicit 'any' is banned. Use 'unknown' and narrow it.");
console.error("");
for (const violation of violations) {
  console.error(`${relative(violation.file)}:${violation.line} contains explicit any`);
}
process.exit(1);
