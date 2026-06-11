#!/usr/bin/env bash
set -u

usage() {
  cat <<'USAGE'
Check whether this computer is ready for local TypeScript, React, and React Native development.

Usage:
  check-dev-setup.sh [--mobile]

Options:
  --mobile        Include extra checks for Expo/React Native iOS and Android development.
  -h, --help      Show this help.

The script is read-only. It prints install guidance for missing tools.
USAGE
}

include_mobile=0

while [ "$#" -gt 0 ]; do
  case "$1" in
    --mobile)
      include_mobile=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

ok_count=0
warn_count=0
fail_count=0

say() {
  printf '%s\n' "$*"
}

ok() {
  ok_count=$((ok_count + 1))
  printf 'ok:   %s\n' "$*"
}

warn() {
  warn_count=$((warn_count + 1))
  printf 'warn: %s\n' "$*"
}

fail() {
  fail_count=$((fail_count + 1))
  printf 'miss: %s\n' "$*"
}

has() {
  command -v "$1" >/dev/null 2>&1
}

version_of() {
  "$@" 2>/dev/null | sed -n '1p'
}

major_version() {
  printf '%s' "$1" | sed -E 's/^v?([0-9]+).*/\1/'
}

install_homebrew_hint() {
  say "      macOS: install Homebrew from https://brew.sh/"
}

check_command() {
  local name="$1"
  local install_hint="$2"
  shift 2

  if has "$name"; then
    ok "$name found: $(version_of "$@")"
  else
    fail "$name is not installed"
    say "      install: $install_hint"
  fi
}

say "Checking local development setup..."
say

case "$(uname -s 2>/dev/null)" in
  Darwin)
    ok "macOS detected"
    ;;
  Linux)
    ok "Linux detected"
    ;;
  *)
    warn "unsupported or unknown OS: $(uname -s 2>/dev/null || echo unknown)"
    ;;
esac

check_command git "https://git-scm.com/downloads or brew install git" git --version
check_command curl "https://curl.se/download.html or brew install curl" curl --version
check_command tar "install system tar or libarchive tools" tar --version
check_command ruby "macOS includes Ruby; otherwise install from https://www.ruby-lang.org/" ruby --version

if has brew; then
  ok "Homebrew found: $(version_of brew --version)"
else
  warn "Homebrew not found"
  install_homebrew_hint
fi

if [ -n "${NVM_DIR:-}" ] && [ -s "$NVM_DIR/nvm.sh" ]; then
  # shellcheck disable=SC1090
  . "$NVM_DIR/nvm.sh"
fi

if has nvm; then
  ok "nvm found: $(version_of nvm --version)"
else
  warn "nvm not found"
  say "      preferred install: https://github.com/nvm-sh/nvm#installing-and-updating"
  say "      after install: nvm install --lts && nvm use --lts"
fi

if has node; then
  node_version="$(node --version)"
  node_major="$(major_version "$node_version")"
  if [ "$node_major" -ge 20 ] 2>/dev/null; then
    ok "Node.js found: $node_version"
  else
    warn "Node.js is $node_version; this stack expects Node >= 20"
    say "      with nvm: nvm install 20 && nvm use 20"
  fi
else
  fail "Node.js is not installed"
  say "      preferred install: nvm install --lts"
fi

check_command npm "install Node.js with nvm; npm ships with Node" npm --version

if has npx; then
  ok "npx found: $(version_of npx --version)"
else
  fail "npx is not installed"
  say "      install Node.js with nvm; npx ships with npm"
fi

if has corepack; then
  ok "corepack found: $(version_of corepack --version)"
else
  warn "corepack not found"
  say "      optional: install Node.js >= 20, then run corepack enable when a repo uses pnpm/yarn"
fi

if has gh; then
  ok "GitHub CLI found: $(version_of gh --version)"
else
  warn "GitHub CLI not found"
  say "      optional: brew install gh, then gh auth login"
fi

if [ "$include_mobile" -eq 1 ]; then
  say
  say "Checking optional mobile development tools..."

  if has xcodebuild; then
    ok "Xcode command line tools found: $(version_of xcodebuild -version)"
  else
    warn "Xcode command line tools not found"
    say "      install Xcode from the App Store, then run: sudo xcode-select --switch /Applications/Xcode.app"
  fi

  if has pod; then
    ok "CocoaPods found: $(version_of pod --version)"
  else
    warn "CocoaPods not found"
    say "      install: sudo gem install cocoapods"
  fi

  if has watchman; then
    ok "Watchman found: $(version_of watchman --version)"
  else
    warn "Watchman not found"
    say "      install: brew install watchman"
  fi

  if [ -n "${ANDROID_HOME:-}" ] || [ -n "${ANDROID_SDK_ROOT:-}" ]; then
    ok "Android SDK environment variable found"
  else
    warn "ANDROID_HOME or ANDROID_SDK_ROOT is not set"
    say "      install Android Studio, then set ANDROID_HOME to the Android SDK path"
  fi
fi

say
say "Summary: $ok_count ok, $warn_count warning(s), $fail_count missing."

if [ "$fail_count" -gt 0 ]; then
  exit 1
fi

exit 0
