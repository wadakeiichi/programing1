#!/bin/bash
set -e

echo "🌀 .devcontainer の最新化を開始します..."

# 作業ツリーを stash に退避
echo "🗂 作業ツリーを stash に退避します..."
stash_result=$(git stash push -m "devcontainer update")
echo "$stash_result"

# リモートの最新を取得
echo "🌐 リモートから最新を取得します..."
git fetch origin

# .devcontainer/ を最新状態に強制上書き
echo "🔁 .devcontainer を最新の origin/main で上書きします..."
git checkout origin/main -- .devcontainer

# 作業内容を復元
if [[ "$stash_result" != "No local changes to save" ]]; then
  echo "📦 作業内容を復元します..."
  git stash pop >/dev/null
else
  echo "📦 復元不要：スタッシュは作成されませんでした"
fi

echo "✅ 完了しました！.devcontainer は最新状態になりました。"
