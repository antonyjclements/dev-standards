#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const ROOT = process.cwd();
const SRC_DIR = path.join(ROOT, "src");
const EXTENSIONS = new Set([".ts", ".tsx"]);
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

function checkProp(file, source, blockStart, name, typeText, violations) {
  const cleanType = typeText.trim();

  if (/^boolean\b/.test(cleanType) && !/^is[A-Z0-9]/.test(name)) {
    violations.push({ file, line: lineNumber(source, blockStart), name, reason: "boolean props should start with is" });
  }

  if (/^\??\s*(?:\([^)]*\)|[A-Za-z_$][\w$]*)\s*=>/.test(cleanType) && /^handle[A-Z0-9]/.test(name)) {
    violations.push({ file, line: lineNumber(source, blockStart), name, reason: "handler props should use on*, not handle*" });
  }

  if (/^\??\s*(?:\([^)]*\)|[A-Za-z_$][\w$]*)\s*=>/.test(cleanType) && /ReactNode|JSX\.Element|Element/.test(cleanType) && !/^render[A-Z0-9]/.test(name)) {
    violations.push({ file, line: lineNumber(source, blockStart), name, reason: "render props should start with render" });
  }

  if (/RefObject|MutableRefObject|LegacyRef|Ref<|React\.Ref/.test(cleanType) && !/Ref$/.test(name)) {
    violations.push({ file, line: lineNumber(source, blockStart), name, reason: "ref props should end with Ref" });
  }
}

const violations = [];

for (const file of walk(SRC_DIR)) {
  const source = stripComments(fs.readFileSync(file, "utf8"));
  const propsBlock = /\b(?:type\s+[A-Za-z_$][\w$]*Props\s*=\s*|interface\s+[A-Za-z_$][\w$]*Props\s*){([\s\S]*?)^}/gm;
  let blockMatch;
  while ((blockMatch = propsBlock.exec(source)) !== null) {
    const block = blockMatch[1];
    const blockOffset = blockMatch.index + blockMatch[0].indexOf(block);
    const propPattern = /^\s*([A-Za-z_$][\w$]*)\??\s*:\s*([^;\n]+)/gm;
    let propMatch;
    while ((propMatch = propPattern.exec(block)) !== null) {
      const propOffset = propMatch.index + Math.max(0, propMatch[0].search(/\S/));
      checkProp(file, source, blockOffset + propOffset, propMatch[1], propMatch[2], violations);
    }
  }
}

if (violations.length === 0) {
  console.log("check-props-naming: prop names look good.");
  process.exit(0);
}

console.error("check-props-naming: found prop names that do not match the React standard.");
console.error("");
for (const violation of violations) {
  console.error(`${relative(violation.file)}:${violation.line} prop '${violation.name}'`);
  console.error(`  ${violation.reason}`);
}
process.exit(1);
