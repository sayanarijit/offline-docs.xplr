---@diagnostic disable
local xplr = xplr
local version = version
---@diagnostic enable

local repo_url = "https://github.com/sayanarijit/xplr"

local fetch_script = [===[#!/usr/bin/env bash
set -e

REPO_URL=%q
VERSION=%q
LOCAL_PATH=%q
DOC_DIR="$LOCAL_PATH/docs"
EXAMPLES_DIR="$LOCAL_PATH/examples"

[ -d "${DOC_DIR:?}" ] && [ -d "${EXAMPLES_DIR:?}" ] && exit 0

TARBALL_URL="${REPO_URL:?}/archive/refs/tags/v${VERSION:?}.tar.gz"
TMP_DIR="$(mktemp -d)"

[ -e "$DOC_DIR" ] && rm -rf -- "${DOC_DIR:?}"
mkdir -p -- "$DOC_DIR"

[ -e "$EXAMPLES_DIR" ] && rm -rf -- "$EXAMPLES_DIR"
mkdir -p -- "$EXAMPLES_DIR"

cd -- "$TMP_DIR"

"$XPLR" -m "LogInfo: Fetching docs for xplr $VERSION ..."

curl -sL "$TARBALL_URL" -o "xplr.tgz"

"$XPLR" -m "LogInfo: Extracting docs ..."

tar -xzf "xplr.tgz"

cd "xplr-$VERSION"

"$XPLR" -m "LogInfo: Storing docs ..."

(cd "./docs/en/src/" && mv -f * "$DOC_DIR/")
mv -f "./src/init.lua" "$EXAMPLES_DIR/init.lua"

cd "$LOCAL_PATH"

"$XPLR" -m "LogInfo: Cleaning up ..."

rm -rf "${TMP_DIR:?}"

"$XPLR" -m "LogSuccess: xplr $VERSION docs is now available offline"
]===]

local function setup(args)
  args = args or {}
  args.mode = args.mode or "action"
  args.key = args.key or "?"
  args.local_path = args.local_path
    or (os.getenv("HOME") .. "/.local/share/xplr/doc/" .. version)

  local script = string.format(fetch_script, repo_url, version, args.local_path)

  xplr.config.modes.builtin[args.mode].key_bindings.on_key[args.key] = {
    help = "offline docs",
    messages = {
      "PopMode",
      { BashExecSilently = script },
      { ChangeDirectory = args.local_path },
    },
  }
end

return { setup = setup }
