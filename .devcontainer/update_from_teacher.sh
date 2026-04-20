#!/bin/bash
# ==========================================================================
# 学生用: 教員リポジトリで手元のファイルを上書きするスクリプト
#   使い方: VS Code ターミナルで `make` と打つだけ
#   動作  : origin/main から教員管理ファイル（.devcontainer / docs など）を
#           取得し、ローカルを教員の最新版で上書きする。
#           学生自身が作成した .py などのファイルはそのまま残る。
# ==========================================================================
set -e

echo "🌀 教員用リポジトリから最新の教材を取得します..."

# Git index.lock の削除（残っていれば）
if [ -f .git/index.lock ]; then
  echo "🔓 index.lock を削除します..."
  rm -f .git/index.lock
fi

# ネットワーク接続（fetch）を試す
echo "🌐 リモートの接続を確認中..."
if ! git fetch origin &>/dev/null; then
  echo "⚠️  ネットワーク接続または git fetch に失敗しました。更新はスキップされました。"
  exit 0
fi
echo "✅ 接続成功：更新を実行します"

# --- 教員が管理するパス（origin/main で上書きする対象） -----------------
# ※ 学生の作業ファイル（*.py など）はここに含めない
TEACHER_PATHS=(
  .devcontainer
  .github
  .vscode
  docs
  .gitattributes
  makefile
  bootstrap.sh
  syncro.sh
  README.md
)

DEVCONTAINER_CHANGED=0

for p in "${TEACHER_PATHS[@]}"; do
  # リモートに存在しないパスはスキップ
  if ! git cat-file -e "origin/main:$p" 2>/dev/null; then
    continue
  fi

  # .devcontainer に差分があればリビルド案内を出すためのフラグ
  if [ "$p" = ".devcontainer" ]; then
    if ! git diff --quiet "origin/main" -- "$p" 2>/dev/null; then
      DEVCONTAINER_CHANGED=1
    fi
  fi

  echo "📥 取得: $p"
  # フォルダはいったん削除してから checkout（削除されたファイルにも追従）
  if [ -d "$p" ]; then
    rm -rf "$p"
  fi
  git checkout "origin/main" -- "$p"
done

# 改行コードの再正規化（Windows の CRLF 対策）
echo "🔄 改行コードを再正規化しています..."
git add --renormalize . >/dev/null 2>&1 || true

# 主要なシェルスクリプト / makefile を LF に強制変換（念のため）
for f in makefile bootstrap.sh syncro.sh \
         .devcontainer/update_devcontainer.sh \
         .devcontainer/update_from_teacher.sh; do
  if [ -f "$f" ]; then
    sed -i 's/\r$//' "$f" 2>/dev/null || true
  fi
done

echo ""
echo "✅ 完了しました！教員用リポジトリで上書きされました。"
echo "   docs/ に新しい教材（例: week3a.md など）が入っていないか確認してください。"

if [ "$DEVCONTAINER_CHANGED" = "1" ]; then
  echo ""
  echo "ℹ️  .devcontainer に変更がありました。左下の「><」マーク →"
  echo "    「コンテナーのリビルド」を実行してください。"
fi
