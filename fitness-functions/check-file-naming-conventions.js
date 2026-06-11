#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const ROOT = process.cwd();
const SRC_DIR = path.join(ROOT, "src");
const BANNED_NAMES = new Set(["utils", "helpers", "constants", "misc", "common", "shared"]);
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

function relative(file) {
  return file.split(path.sep).join("/").replace(ROOT.split(path.sep).join("/") + "/", "");
}

function basenameWithoutExtensions(file) {
  return path.basename(file).replace(/\.(test|spec)\.[^.]+$/, "").replace(/\.[^.]+$/, "");
}

function isIndexFile(file) {
  return path.basename(file).startsWith("index.");
}

function isDeclarationFile(file) {
  return file.endsWith(".d.ts");
}

const violations = [];

for (const file of walk(SRC_DIR)) {
  if (isDeclarationFile(file) || isIndexFile(file)) continue;

  const name = basenameWithoutExtensions(file);
  const lower = name.toLowerCase();

  if (BANNED_NAMES.has(lower)) {
    violations.push({
      file,
      reason: `'${path.basename(file)}' is a dumping-ground filename; name the file by its specific purpose`,
    });
  }

  if (path.extname(file) === ".tsx" && /^[a-z]/.test(name) && !name.startsWith("use")) {
    violations.push({
      file,
      reason: "React component files should be PascalCase.tsx, while hook files should start with use",
    });
  }

  if (name.startsWith("use") && !/^use[A-Z0-9]/.test(name)) {
    violations.push({
      file,
      reason: "hook filenames should follow useThing.ts or useThing.tsx",
    });
  }
}

if (violations.length === 0) {
  console.log("check-file-naming-conventions: filenames look good.");
  process.exit(0);
}

console.error("check-file-naming-conventions: found filenames that do not match the standard.");
console.error("");
for (const violation of violations) {
  console.error(`${relative(violation.file)}`);
  console.error(`  ${violation.reason}`);
}
process.exit(1);
