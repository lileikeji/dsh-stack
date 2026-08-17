#!/usr/bin/env bash
# dsh-stack 装配脚本 —— 克隆全部 bundle 插件到 ./plugins 并安装到 web profile。
# 用法: bash scripts/bootstrap.sh [DSH_ROOT]
set -euo pipefail

DSH_ROOT="${1:-$PWD/deepseek-harness}"
STACK="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLUGINS_DIR="$STACK/plugins"
mkdir -p "$PLUGINS_DIR"

PLUGINS=(
  # 自有/核心（★ 建议必装）
  "lileikeji/dsh-llm-auto-router"
  "lileikeji/dsh-crosstalk"
  "lileikeji/dsh-vision-toolkit"
  "lileikeji/dsh-vision-assist"
  "lileikeji/dsh-image-gen"
  "lileikeji/dsh-auto-compact"
  "lileikeji/dsh-auto-continue"
  "lileikeji/dsh-super-injector"
  "lileikeji/dsh-token-usage"
  # 第三方
  "ishuowang/dsh-agent-team-room"
  "xiaobright/dsh-anchored-standard"
  "Khorsheed/dsh-ankh-guard"
  "mayf3/dsh-session-doctor"
  "jiamuAi/dsh-token-usage"
  "yjh051108/dsh-routing-suite"
  "zhu1090093659/dsh-web-ui"
)

profile="${DSH_ROOT}/profiles/web"

echo "==> DSH root: $DSH_ROOT"
echo "==> Installing bundles to profile: $profile"

for repo in "${PLUGINS[@]}"; do
  name="$(basename "$repo")"
  if [ ! -d "$PLUGINS_DIR/$name" ]; then
    echo "==> cloning $repo"
    git clone --depth 1 "https://github.com/$repo.git" "$PLUGINS_DIR/$name"
  fi
  ( cd "$PLUGINS_DIR/$name" && [ -x scripts/build.sh ] && bash scripts/build.sh || true )
  ( cd "$DSH_ROOT" && pnpm dsh plugin --profile web add "$PLUGINS_DIR/$name" || true )
done

echo "==> done. Then:"
echo "    cp $(dirname "$STACK")/dsh-stack/config-templates/settings.example.yaml ~/.dsh/settings.yaml"
echo "    cp -r $(dirname "$STACK")/dsh-stack/presets/* ~/.dsh/.agent-presets/"
echo "    pnpm dsh --profile web"
