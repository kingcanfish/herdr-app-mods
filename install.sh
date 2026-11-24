#!/bin/sh
# Install these Herdr app customizations into the Herdr app home.
#
#   ./install.sh               copy mods, layout and theme, merge look settings, switch layout
#   ./install.sh --no-settings leave settings.json alone (keep your fonts and theme)
#
# Anything it would overwrite is first copied to <home>/backups/herdr-app-mods-<time>/.
set -eu

repo="$(cd "$(dirname "$0")" && pwd)"
home="${HERDR_APP_HOME:-$HOME/.config/herdr-app}"
settings=1
for arg in "$@"; do
  case "$arg" in
    --no-settings) settings=0 ;;
    -h|--help) sed -n '2,8p' "$0"; exit 0 ;;
    *) echo "unknown option: $arg" >&2; exit 2 ;;
  esac
done

if [ ! -d "$home" ]; then
  echo "No Herdr app home at $home. Open Herdr once, or set HERDR_APP_HOME." >&2
  exit 1
fi

backup="$home/backups/herdr-app-mods-$(date +%Y%m%d-%H%M%S)"
save() {
  if [ -e "$home/$1" ]; then
    mkdir -p "$backup/$(dirname "$1")"
    cp -R "$home/$1" "$backup/$1"
  fi
}

for m in "$repo"/mods/*/; do
  name="$(basename "$m")"
  save "mods/$name"
  mkdir -p "$home/mods/$name"
  cp "$m"main.js "$m"mod.json "$m"jsconfig.json "$home/mods/$name/"
  # Editor typings: Herdr writes them beside its own mods; borrow them if there.
  [ -f "$home/mods/agents/gpui-kit.d.ts" ] && cp "$home/mods/agents/gpui-kit.d.ts" "$home/mods/$name/"
done

mkdir -p "$home/layouts" "$home/themes"
save layouts/my-main.json
cp "$repo/layouts/my-main.json" "$home/layouts/"
save themes/ghostty.json
cp "$repo/themes/ghostty.json" "$home/themes/"

if [ "$settings" = 1 ]; then
  save settings.json
  python3 - "$home/settings.json" "$repo/settings.example.json" <<'PY'
import json, os, sys
target, example = sys.argv[1], sys.argv[2]
current = json.load(open(target)) if os.path.exists(target) else {}
current.update(json.load(open(example)))
with open(target, "w") as f:
    json.dump(current, f, indent=2, ensure_ascii=False)
PY
fi

[ -d "$backup" ] && echo "Backed up what was replaced to $backup"

app=""
for p in "$HOME/Applications/Herdr.app" "/Applications/Herdr.app"; do
  [ -x "$p/Contents/MacOS/Herdr" ] && app="$p/Contents/MacOS/Herdr" && break
done
if [ -n "$app" ] && "$app" do layout.switch '{"name":"my-main"}' >/dev/null 2>&1; then
  echo "Installed and switched Herdr to the my-main layout."
else
  echo "Installed. In Herdr, switch to the my-main layout (command palette: Switch layout)."
fi
