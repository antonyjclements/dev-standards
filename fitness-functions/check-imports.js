#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const ROOT = process.cwd();
const SRC_DIR = path.join(ROOT, "src");
const SOURCE_EXTENSIONS = new Set([
  ".js",
  ".jsx",
  ".ts",
  ".tsx",
  ".mjs",
  ".mts",
  ".cjs",
  ".cts",
]);
const IGNORED_DIRS = new Set([
  ".git",
  "node_modules",
  "dist",
  "build",
  "coverage",
  ".expo",
  ".next",
  ".turbo",
]);

function walk(dir) {
  if (!fs.existsSync(dir)) return [];

  const entries = fs.readdirSync(dir, { withFileTypes: true });
  const files = [];

  for (const entry of entries) {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      if (!IGNORED_DIRS.has(entry.name)) files.push(...walk(fullPath));
      continue;
    }

    if (entry.isFile() && SOURCE_EXTENSIONS.has(path.extname(entry.name))) {
      files.push(fullPath);
    }
  }

  return files;
}

function stripComments(source) {
  return source
    .replace(/\/\*[\s\S]*?\*\//g, "")
    .replace(/(^|[^:])\/\/.*$/gm, "$1");
}

function importsFrom(source) {
  const clean = stripComments(source);
  const imports = [];
  const patterns = [
    /\bimport\s+(?:type\s+)?(?:[\s\S]*?\s+from\s+)?["']([^"']+)["']/g,
    /\bexport\s+(?:type\s+)?[\s\S]*?\s+from\s+["']([^"']+)["']/g,
    /\bimport\s*\(\s*["']([^"']+)["']\s*\)/g,
    /\brequire\s*\(\s*["']([^"']+)["']\s*\)/g,
  ];

  for (const pattern of patterns) {
    let match;
    while ((match = pattern.exec(clean)) !== null) {
      imports.push(match[1]);
    }
  }

  return imports;
}

function normalizePath(filePath) {
  return filePath.split(path.sep).join("/");
}

function layerForSrcRelative(srcRelativePath) {
  const parts = normalizePath(srcRelativePath).split("/");

  if (parts[0] === "app") {
    return { layer: "app" };
  }

  if (parts[0] === "common") {
    return { layer: "common" };
  }

  if (parts[0] === "features" && parts[1]) {
    return { layer: "feature", feature: parts[1] };
  }

  if (parts[0] === "features") {
    return { layer: "feature", feature: "(features root)" };
  }

  return { layer: "unknown" };
}

function layerForFile(filePath) {
  const relative = path.relative(SRC_DIR, filePath);
  if (relative.startsWith("..")) return { layer: "outside" };
  return layerForSrcRelative(relative);
}

function resolveAlias(importPath) {
  const exactAliases = {
    "@app": "app",
    "@features": "features",
    "@common": "common",
    "~app": "app",
    "~features": "features",
    "~common": "common",
  };

  if (exactAliases[importPath]) {
    return exactAliases[importPath];
  }

  const aliases = [
    ["@app/", "app/"],
    ["@features/", "features/"],
    ["@common/", "common/"],
    ["@/", ""],
    ["~app/", "app/"],
    ["~features/", "features/"],
    ["~common/", "common/"],
    ["~/", ""],
  ];

  for (const [prefix, target] of aliases) {
    if (importPath.startsWith(prefix)) {
      return target + importPath.slice(prefix.length);
    }
  }

  return null;
}

function resolveRelative(fromFile, importPath) {
  if (!importPath.startsWith(".")) return null;

  const fromDir = path.dirname(fromFile);
  const absolute = path.resolve(fromDir, importPath);
  const relative = path.relative(SRC_DIR, absolute);
  if (relative.startsWith("..")) return null;

  return relative;
}

function importedLayer(fromFile, importPath) {
  const aliasRelative = resolveAlias(importPath);
  if (aliasRelative !== null) return layerForSrcRelative(aliasRelative);

  const relativePath = resolveRelative(fromFile, importPath);
  if (relativePath !== null) return layerForSrcRelative(relativePath);

  return { layer: "external" };
}

function violationFor(source, target) {
  if (source.layer === "common" && target.layer === "app") {
    return "common must not import from app";
  }

  if (source.layer === "common" && target.layer === "feature") {
    return "common must not import from features";
  }

  if (source.layer === "feature" && target.layer === "app") {
    return "features must not import from app";
  }

  if (
    source.layer === "feature" &&
    target.layer === "feature" &&
    source.feature !== target.feature
  ) {
    return `feature '${source.feature}' must not import feature '${target.feature}'`;
  }

  return null;
}

function formatLocation(filePath) {
  return normalizePath(path.relative(ROOT, filePath));
}

function main() {
  const files = walk(SRC_DIR);
  const violations = [];

  for (const file of files) {
    const source = layerForFile(file);
    if (!["app", "feature", "common"].includes(source.layer)) continue;

    const sourceText = fs.readFileSync(file, "utf8");
    for (const importPath of importsFrom(sourceText)) {
      const target = importedLayer(file, importPath);
      const violation = violationFor(source, target);
      if (violation) {
        violations.push({
          file,
          importPath,
          violation,
        });
      }
    }
  }

  if (violations.length === 0) {
    console.log("check-imports: architecture imports look good.");
    return;
  }

  console.error("check-imports: found three-layer architecture import violations.");
  console.error("");

  for (const { file, importPath, violation } of violations) {
    console.error(`${formatLocation(file)} imports '${importPath}'`);
    console.error(`  ${violation}`);
  }

  console.error("");
  console.error("Allowed direction: app -> features -> common.");
  console.error("Cross-feature imports should move through app composition or shared common code.");
  process.exit(1);
}

main();
