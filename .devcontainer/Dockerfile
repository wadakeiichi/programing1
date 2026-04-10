# 元のベースイメージ
FROM mcr.microsoft.com/devcontainers/python:1-3.12-bullseye

# Yarn リポジトリの GPG キー期限切れ対策
RUN rm -f /etc/apt/sources.list.d/yarn.list

# git を追加でインストール
RUN apt-get update && apt-get install -y git && apt-get clean
