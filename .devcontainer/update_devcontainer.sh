#!/bin/bash
set -e

echo "🌀 .devcontainer の最新化を開始します..."

# Git index.lock の削除（残っていれば）
if [ -f .git/index.lock ]; then
  echo "🔓 index.lock を削除します..."
  rm -f .git/index.lock
fi

# ネットワーク接続（fetch）を試す
echo "🌐 リモートの接続を確認中..."
if git fetch origin &>/dev/null; then
  echo "✅ 接続成功：更新を実行します"

  # ローカルの .devcontainer を削除
  echo "🧹 ローカルの .devcontainer を削除します..."
  rm -rf .devcontainer

  # リモートから .devcontainer を取得
  echo "📥 リモートから .devcontainer を取得します..."
  git checkout origin/main -- .devcontainer

  echo "✅ 完了しました！.devcontainer は教員用で上書きされました。"

else
  echo "⚠️ ネットワーク接続または git fetch に失敗しました。更新はスキップされました。"
  exit 0
fi
