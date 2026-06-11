#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const ROOT = process.cwd();
const SRC_DIR = path.join(ROOT, "src");
const TEST_FILE = /\.(test|spec)\.[jt]sx?$/;
const IGNORED_DIRS = new Set([".git", "node_modules", "dist", "build", "coverage", ".expo", ".next", ".turbo"]);

function walk(dir) {
  if (!fs.existsSync(dir)) return [];
  return fs.readdirSync(dir, { withFileTypes: true }).flatMap((entry) => {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) return IGNORED_DIRS.has(entry.name) ? [] : walk(fullPath);
    return entry.isFile() && TEST_FILE.test(entry.name) ? [fullPath] : [];
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

const weakNames = new Set(["works", "handles errors", "test", "does stuff"]);
const violations = [];

for (const file of walk(SRC_DIR)) {
  const source = stripComments(fs.readFileSync(file, "utf8"));
  const pattern = /\b(?:it|test)\s*\(\s*["'`]([^"'`]+)["'`]/g;
  let match;
  while ((match = pattern.exec(source)) !== null) {
    const name = match[1].trim();
    const lower = name.toLowerCase();
    if (/\bshould\b/.test(lower) || weakNames.has(lower)) {
      violations.push({ file, line: lineNumber(source, match.index), name });
    }
  }
}

if (violations.length === 0) {
  console.log("check-test-naming: test names look good.");
  process.exit(0);
}

console.error("check-test-naming: test names should be present-tense behavior statements without 'should'.");
console.error("");
for (const violation of violations) {
  console.error(`${relative(violation.file)}:${violation.line} "${violation.name}"`);
}
process.exit(1);
