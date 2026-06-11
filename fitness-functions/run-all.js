#!/usr/bin/env node

const { spawnSync } = require("child_process");
const path = require("path");

const CHECKS = [
  "check-imports.js",
  "check-function-declarations.js",
  "check-file-naming-conventions.js",
  "check-named-exports.js",
  "check-no-any.js",
  "check-types-over-interfaces.js",
  "check-props-naming.js",
  "check-test-naming.js",
];

let failed = false;

for (const check of CHECKS) {
  const checkPath = path.join(__dirname, check);
  const result = spawnSync(process.execPath, [checkPath], {
    cwd: process.cwd(),
    stdio: "inherit",
  });

  if (result.status !== 0) {
    failed = true;
  }
}

if (failed) {
  process.exit(1);
}

console.log("fitness: all checks passed.");
