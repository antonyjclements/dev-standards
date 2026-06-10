#!/usr/bin/env bash
set -euo pipefail

# Source of truth for the published one-liner. Override with --ref or env.
OWNER_REPO="${DEV_STANDARDS_REPO:-antonyjclements/dev-standards}"
REF="${DEV_STANDARDS_REF:-main}"

usage() {
  cat <<'USAGE'
dev-standards — pull reusable engineering standards into any repo.

Usage:
  install.sh list
  install.sh add <pack...> [options]

Commands:
  list             Show available standards packs.
  add <pack...>    Copy packs into <repo>/docs/standards/ and update index.yml.

Options:
  --repo PATH      Target repo (default: current directory).
  --ref BRANCH     Git ref to fetch when running remotely (default: main).
  --source DIR     Use a local checkout instead of fetching from GitHub.
  --force          Overwrite standard files that already exist.
  -h, --help       Show this help.

Examples:
  bash <(curl -fsSL https://raw.githubusercontent.com/antonyjclements/dev-standards/main/install.sh) list
  bash <(curl -fsSL https://raw.githubusercontent.com/antonyjclements/dev-standards/main/install.sh) add react typescript
USAGE
}

cmd="${1:-}"
[ "$#" -gt 0 ] && shift || true

repo="$(pwd)"
ref="$REF"
source_dir=""
force=0
packs=()

while [ "$#" -gt 0 ]; do
  case "$1" in
    --repo)   repo="$2"; shift 2 ;;
    --ref)    ref="$2"; shift 2 ;;
    --source) source_dir="$2"; shift 2 ;;
    --force)  force=1; shift ;;
    -h|--help) usage; exit 0 ;;
    --*) echo "unknown option: $1" >&2; exit 2 ;;
    *) packs+=("$1"); shift ;;
  esac
done

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || true)"
tmp=""
cleanup() { [ -n "$tmp" ] && rm -rf "$tmp"; }
trap cleanup EXIT

resolve_source() {
  if [ -n "$source_dir" ]; then echo "$source_dir"; return; fi
  if [ -n "$script_dir" ] && [ -d "$script_dir/standards" ]; then echo "$script_dir"; return; fi
  command -v curl >/dev/null 2>&1 || { echo "curl is required for remote install" >&2; exit 1; }
  command -v tar  >/dev/null 2>&1 || { echo "tar is required for remote install" >&2; exit 1; }
  tmp="$(mktemp -d "${TMPDIR:-/tmp}/dev-standards.XXXXXX")"
  curl -fsSL "https://github.com/$OWNER_REPO/archive/refs/heads/$ref.tar.gz" -o "$tmp/src.tgz"
  tar -xzf "$tmp/src.tgz" -C "$tmp"
  local found
  found="$(find "$tmp" -maxdepth 2 -type d -name standards -print -quit)"
  [ -n "$found" ] || { echo "could not locate standards/ in fetched archive" >&2; exit 1; }
  dirname "$found"
}

require_ruby() {
  command -v ruby >/dev/null 2>&1 || { echo "ruby is required to update docs/standards/index.yml" >&2; exit 1; }
}

case "$cmd" in
  ""|-h|--help) usage; exit 0 ;;
esac

SRC="$(resolve_source)"
[ -d "$SRC/standards" ] || { echo "no standards/ directory in source: $SRC" >&2; exit 1; }

case "$cmd" in
  list)
    echo "Available standards packs:"
    for d in "$SRC"/standards/*/; do
      [ -d "$d" ] || continue
      p="$(basename "$d")"
      n=$(find "$d" -maxdepth 1 -name '*.md' | wc -l | tr -d ' ')
      printf "  %-14s %s standard(s)\n" "$p" "$n"
    done
    echo
    echo "Add with: install.sh add <pack...>"
    ;;

  add)
    [ "${#packs[@]}" -gt 0 ] || { echo "specify at least one pack (see: install.sh list)" >&2; exit 2; }
    require_ruby
    mkdir -p "$repo/docs/standards"
    for p in "${packs[@]}"; do
      [ -d "$SRC/standards/$p" ] || { echo "unknown pack: $p (see: install.sh list)" >&2; exit 1; }
      dest="$repo/docs/standards/$p"
      mkdir -p "$dest"
      for f in "$SRC/standards/$p"/*.md; do
        [ -e "$f" ] || continue
        base="$(basename "$f")"
        if [ -e "$dest/$base" ] && [ "$force" -ne 1 ]; then
          echo "preserve: docs/standards/$p/$base (use --force to overwrite)"
        else
          cp "$f" "$dest/$base"
          echo "write: docs/standards/$p/$base"
        fi
      done
      if [ -f "$SRC/standards/$p/index.yml" ]; then
        ruby "$SRC/scripts/merge-index.rb" "$repo/docs/standards/index.yml" "$SRC/standards/$p/index.yml"
        echo "indexed: $p -> docs/standards/index.yml"
      fi
    done
    echo
    echo "Done. ${#packs[@]} pack(s) added to $repo/docs/standards/."
    echo "Agents using agentic-workflow will pick them up via docs/standards/index.yml."
    ;;

  *)
    echo "unknown command: $cmd" >&2
    usage >&2
    exit 2
    ;;
esac
