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

  # .gitattributes と makefile も最新化
  echo "📥 リモートから .gitattributes / makefile を取得します..."
  git checkout origin/main -- .gitattributes makefile

  # 改行コードの再正規化（Windows の CRLF 対策）
  echo "🔄 改行コードを再正規化しています..."
  git add --renormalize . >/dev/null 2>&1 || true

  # 念のため主要なシェルスクリプトと makefile を直接 LF に変換
  for f in makefile .devcontainer/update_devcontainer.sh bootstrap.sh syncro.sh; do
    if [ -f "$f" ]; then
      sed -i 's/\r$//' "$f" 2>/dev/null || true
    fi
  done

  echo "✅ 完了しました！.devcontainer / .gitattributes / makefile は教員用で上書きされました。"

else
  echo "⚠️ ネットワーク接続または git fetch に失敗しました。更新はスキップされました。"
  exit 0
fi
