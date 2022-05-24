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

echo "LogInfo: Fetching docs for xplr $VERSION ..." | tee -a "$XPLR_PIPE_MSG_IN"

curl -sL "$TARBALL_URL" -o "xplr.tgz"

echo "LogInfo: Extracting docs ..." | tee -a "$XPLR_PIPE_MSG_IN"

tar -xzf "xplr.tgz"

cd "xplr-$VERSION"

echo "LogInfo: Storing docs ..." | tee -a "$XPLR_PIPE_MSG_IN"

(cd "./docs/en/src/" && mv -f * "$DOC_DIR/")
mv -f "./src/init.lua" "$EXAMPLES_DIR/init.lua"

cd "$LOCAL_PATH"

echo "LogInfo: Cleaning up ..." | tee -a "$XPLR_PIPE_MSG_IN"

rm -rf "${TMP_DIR:?}"

echo "LogSuccess: xplr $VERSION docs is now available offline" | tee -a "$XPLR_PIPE_MSG_IN"
]===]

local function setup(args)
  args = args or {}
  args.mode = args.mode or "action"
  args.key = args.key or "?"
  args.local_path = args.local_path
    or (os.getenv("HOME") .. "/.local/share/xplr/doc")

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
