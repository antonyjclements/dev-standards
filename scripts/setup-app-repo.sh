#!/usr/bin/env bash
set -euo pipefail

DEV_STANDARDS_REPO="${DEV_STANDARDS_REPO:-antonyjclements/dev-standards}"
DEV_STANDARDS_REF="${DEV_STANDARDS_REF:-main}"
DEV_STANDARDS_RAW_BASE="${DEV_STANDARDS_RAW_BASE:-https://raw.githubusercontent.com/$DEV_STANDARDS_REPO/$DEV_STANDARDS_REF}"
AGENTIC_WORKFLOW_INSTALL_URL="${AGENTIC_WORKFLOW_INSTALL_URL:-https://raw.githubusercontent.com/antonyjclements/agentic-workflow/main/skills/aw-init/scripts/install.sh}"

usage() {
  cat <<'USAGE'
Create a new React or React Native repository and install agent workflow standards.

Usage:
  setup-app-repo.sh web <path> [options]
  setup-app-repo.sh mobile <path> [options]

Arguments:
  web             Create a Vite React + TypeScript repository.
  mobile          Create an Expo React Native + TypeScript repository.
  path            Directory to create. The final path must not already contain files.

Options:
  --name NAME     Package/app name to pass to the scaffold tool.
  --no-git        Do not initialize a git repository. Husky hooks are written but not activated.
  --force         Pass --force to agentic-workflow and standards installers.
  -h, --help      Show this help.

Environment overrides:
  DEV_STANDARDS_REPO             GitHub repo for standards, default antonyjclements/dev-standards.
  DEV_STANDARDS_REF              Git ref for standards, default main.
  DEV_STANDARDS_SOURCE           Local dev-standards checkout to use instead of GitHub.
  DEV_STANDARDS_RAW_BASE         Raw GitHub base URL for fetched fitness functions.
  AGENTIC_WORKFLOW_INSTALL_URL   Raw aw-init installer URL.

Examples:
  scripts/setup-app-repo.sh web ~/Development/my-web-app
  scripts/setup-app-repo.sh mobile ~/Development/my-mobile-app --name my-mobile-app
USAGE
}

kind="${1:-}"
case "$kind" in
  web|mobile)
    shift
    ;;
  ""|-h|--help)
    usage
    exit 0
    ;;
  *)
    echo "first argument must be 'web' or 'mobile'" >&2
    usage >&2
    exit 2
    ;;
esac

target="${1:-}"
if [ -z "$target" ]; then
  echo "missing target path" >&2
  usage >&2
  exit 2
fi
shift

app_name=""
init_git=1
force=0

while [ "$#" -gt 0 ]; do
  case "$1" in
    --name)
      [ "$#" -ge 2 ] || { echo "missing value for --name" >&2; exit 2; }
      app_name="$2"
      shift 2
      ;;
    --no-git)
      init_git=0
      shift
      ;;
    --force)
      force=1
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

has() {
  command -v "$1" >/dev/null 2>&1
}

require_command() {
  local cmd="$1"
  local hint="$2"
  if ! has "$cmd"; then
    echo "missing required command: $cmd" >&2
    echo "install: $hint" >&2
    exit 1
  fi
}

absolute_path() {
  local path="$1"
  case "$path" in
    /*) printf '%s\n' "$path" ;;
    ~) printf '%s\n' "$HOME" ;;
    ~/*) printf '%s/%s\n' "$HOME" "${path#~/}" ;;
    *) printf '%s/%s\n' "$(pwd)" "$path" ;;
  esac
}

package_name_from_path() {
  basename "$1" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9._-]+/-/g; s/^-+//; s/-+$//'
}

run_standards_installer() {
  local repo="$1"
  local force_arg=()
  if [ "$force" -eq 1 ]; then
    force_arg=(--force)
  fi

  if [ -n "${DEV_STANDARDS_SOURCE:-}" ]; then
    bash "$DEV_STANDARDS_SOURCE/install.sh" add react typescript testing --repo "$repo" --source "$DEV_STANDARDS_SOURCE" "${force_arg[@]}"
    return
  fi

  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local local_source
  local_source="$(cd "$script_dir/.." && pwd)"

  if [ -d "$local_source/standards" ] && [ -f "$local_source/install.sh" ]; then
    bash "$local_source/install.sh" add react typescript testing --repo "$repo" --source "$local_source" "${force_arg[@]}"
    return
  fi

  bash <(curl -fsSL "https://raw.githubusercontent.com/$DEV_STANDARDS_REPO/$DEV_STANDARDS_REF/install.sh") add react typescript testing --repo "$repo" "${force_arg[@]}"
}

install_fitness_functions() {
  local repo="$1"
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local local_source
  local_source="$(cd "$script_dir/.." && pwd)"
  local source_dir=""
  local fitness_functions=(
    run-all.js
    check-imports.js
    check-function-declarations.js
    check-file-naming-conventions.js
    check-named-exports.js
    check-no-any.js
    check-types-over-interfaces.js
    check-props-naming.js
    check-test-naming.js
  )

  if [ -n "${DEV_STANDARDS_SOURCE:-}" ] && [ -d "$DEV_STANDARDS_SOURCE/fitness-functions" ]; then
    source_dir="$DEV_STANDARDS_SOURCE/fitness-functions"
  elif [ -d "$local_source/fitness-functions" ]; then
    source_dir="$local_source/fitness-functions"
  fi

  mkdir -p "$repo/.scripts/fitness-functions" "$repo/.husky"

  for function_file in "${fitness_functions[@]}"; do
    if [ -n "$source_dir" ]; then
      cp "$source_dir/$function_file" "$repo/.scripts/fitness-functions/$function_file"
    else
      curl -fsSL "$DEV_STANDARDS_RAW_BASE/fitness-functions/$function_file" -o "$repo/.scripts/fitness-functions/$function_file"
    fi
    chmod +x "$repo/.scripts/fitness-functions/$function_file"
    echo "write: .scripts/fitness-functions/$function_file"
  done

  npm pkg set scripts.check:fitness="node .scripts/fitness-functions/run-all.js" >/dev/null
  npm pkg set scripts.check:imports="node .scripts/fitness-functions/check-imports.js" >/dev/null
  npm pkg set scripts.prepare="husky" >/dev/null
  npm pkg set devDependencies.husky="^9.1.7" >/dev/null

  printf '%s\n' 'npm run check:fitness' > "$repo/.husky/pre-commit"
  printf '%s\n' 'npm run check:fitness' > "$repo/.husky/pre-push"
  chmod +x "$repo/.husky/pre-commit" "$repo/.husky/pre-push"
  echo "write: .husky/pre-commit"
  echo "write: .husky/pre-push"

  if [ -d "$repo/.git" ] && has git; then
    git -C "$repo" config core.hooksPath .husky
  fi
}

require_command node "install nvm from https://github.com/nvm-sh/nvm, then nvm install --lts"
require_command npm "install Node.js with nvm; npm ships with Node"
require_command npx "install Node.js with nvm; npx ships with npm"
require_command curl "https://curl.se/download.html or brew install curl"
require_command ruby "macOS includes Ruby; otherwise install Ruby from https://www.ruby-lang.org/"

if [ "$init_git" -eq 1 ]; then
  require_command git "https://git-scm.com/downloads or brew install git"
fi

target_dir="$(absolute_path "$target")"
if [ -e "$target_dir" ] && [ "$(find "$target_dir" -mindepth 1 -maxdepth 1 | wc -l | tr -d ' ')" != "0" ]; then
  echo "target directory already exists and is not empty: $target_dir" >&2
  exit 1
fi

mkdir -p "$(dirname "$target_dir")"

if [ -z "$app_name" ]; then
  app_name="$(package_name_from_path "$target_dir")"
fi

echo "Creating $kind app at $target_dir..."

case "$kind" in
  web)
    npm create vite@latest "$target_dir" -- --template react-ts
    ;;
  mobile)
    npx create-expo-app@latest "$target_dir" --template blank-typescript
    ;;
esac

cd "$target_dir"

if [ "$app_name" != "$(package_name_from_path "$target_dir")" ] && [ -f package.json ]; then
  npm pkg set "name=$app_name" >/dev/null
fi

if [ ! -f .nvmrc ]; then
  printf '20\n' > .nvmrc
  echo "write: .nvmrc"
fi

if [ "$init_git" -eq 1 ] && [ ! -d .git ]; then
  git init
fi

agentic_force_arg=()
if [ "$force" -eq 1 ]; then
  agentic_force_arg=(--force)
fi

echo
echo "Installing agentic-workflow..."
bash <(curl -fsSL "$AGENTIC_WORKFLOW_INSTALL_URL") --repo "$target_dir" --remote "${agentic_force_arg[@]}"

echo
echo "Installing standards packs: react, typescript, testing..."
run_standards_installer "$target_dir"

echo
echo "Installing fitness functions..."
install_fitness_functions "$target_dir"

echo
echo "Done."
echo "Next steps:"
echo "  cd \"$target_dir\""
echo "  nvm use"
echo "  npm install"
echo "  npm run prepare"
if [ "$kind" = "web" ]; then
  echo "  npm run dev"
else
  echo "  npx expo start"
fi
