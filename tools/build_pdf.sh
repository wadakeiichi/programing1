#!/usr/bin/env bash
# プログラミングI 教材を Pandoc + XeLaTeX で配布用 PDF にする。
#
# 使い方:
#   bash tools/build_pdf.sh            # docs/ の全 week*.md と syllabus を PDF 化
#   bash tools/build_pdf.sh week8      # docs/week8.md だけ PDF 化
#   bash tools/build_pdf.sh docs/foo.md
#
# 出力は同じフォルダ（docs/）に *.pdf として置かれる（.gitignore 済み）。
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DOCS="$ROOT/docs"
TOOLS="$ROOT/tools"
HEADER="$TOOLS/pandoc/header.tex"

command -v pandoc   >/dev/null || { echo "❌ pandoc が見つかりません"; exit 1; }
command -v xelatex  >/dev/null || { echo "❌ xelatex が見つかりません"; exit 1; }

build_one() {
  local md="$1"
  local base out tmp
  base="$(basename "$md" .md)"
  out="$(dirname "$md")/$base.pdf"
  tmp="$(mktemp).md"
  python3 "$TOOLS/mdfix.py" "$md" > "$tmp"
  pandoc "$tmp" \
    --from=markdown \
    --pdf-engine=xelatex \
    --include-in-header="$HEADER" \
    --highlight-style=tango \
    -V documentclass=article \
    -V fontsize=10pt \
    -V linkcolor=blue -V urlcolor=blue \
    -o "$out"
  rm -f "$tmp"
  echo "✅ $out"
}

resolve() {
  # 引数を docs/<name>.md に解決する
  local a="$1"
  if [ -f "$a" ]; then echo "$a"; return; fi
  if [ -f "$DOCS/$a" ]; then echo "$DOCS/$a"; return; fi
  if [ -f "$DOCS/$a.md" ]; then echo "$DOCS/$a.md"; return; fi
  echo ""; return
}

if [ "$#" -ge 1 ]; then
  for a in "$@"; do
    md="$(resolve "$a")"
    [ -n "$md" ] || { echo "⚠️  見つかりません: $a"; continue; }
    build_one "$md"
  done
else
  shopt -s nullglob
  for md in "$DOCS"/week*.md "$DOCS"/syllabus2026.md; do
    build_one "$md"
  done
fi
