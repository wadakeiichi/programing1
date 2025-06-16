#!/bin/bash
set -e

echo "🧪 .devcontainer の自己更新チェック..."

if git fetch origin &>/dev/null; then
  echo "リモートに接続成功。最新の .devcontainer を取得します。"
  rm -rf .devcontainer
  git checkout origin/main -- .devcontainer
  echo " "
  make -f makefile update-devcontainer
  echo "更新完了. 左下の><開発コンテナー、アイコンから「コンテナーのリビルド」を選択してください。"
else
  echo "リモートに接続できません。スキップします。"
fi
