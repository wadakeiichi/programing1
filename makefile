.PHONY: sync update update-devcontainer pdf

# `make` と打つだけで実行されるデフォルトターゲット
.DEFAULT_GOAL := sync

# 教員用リポジトリで手元のファイルを上書きする（docs/ 等に新教材が入る）
sync:
	@if [ ! -f .devcontainer/update_from_teacher.sh ]; then \
	  echo "📥 update_from_teacher.sh が手元にありません。origin/main から取得します..."; \
	  git fetch origin && git checkout origin/main -- .devcontainer/update_from_teacher.sh || { \
	    echo "❌ 取得に失敗しました。ネットワークか教員リポジトリを確認してください。"; exit 1; }; \
	fi
	bash .devcontainer/update_from_teacher.sh

# 旧互換: `make update` でも同じ動作
update: sync

# `.devcontainer` だけを更新したい場合（互換用）
update-devcontainer:
	bash .devcontainer/update_devcontainer.sh

# 教材を配布用 PDF に変換する（Pandoc + XeLaTeX。教員用、要 pandoc/xelatex）
#   make pdf              … docs/ の全 week*.md と syllabus を PDF 化
#   make pdf FILE=week8   … docs/week8.md だけ PDF 化
# 生成物は docs/*.pdf（.gitignore 済みなので学生には配布されない）
pdf:
	bash tools/build_pdf.sh $(FILE)
