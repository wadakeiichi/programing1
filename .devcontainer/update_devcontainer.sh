#!/bin/bash
set -e

echo "🌀 .devcontainer の最新化を開始します..."

# ローカルの .devcontainer を削除（変更があっても問答無用で破棄）
echo "🧹 ローカルの .devcontainer を削除します..."
rm -rf .devcontainer

# リモートから取得（強制）
echo "🌐 リモートから最新の .devcontainer を取得します..."
git fetch origin
git checkout origin/main -- .devcontainer

echo "✅ 完了しました！.devcontainer は教員用で上書きされました。"
