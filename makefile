.PHONY: sync update update-devcontainer

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
