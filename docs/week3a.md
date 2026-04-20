# Week 3a — 環境設定チェック（Week 1〜2 の確認）

**対象**: プログラミング I 受講生
**所要時間**: 5〜10 分程度
**目的**: Week 3b（Python の書き方のルール）に進む前に、Week 2 で設定したはずの VS Code と Dev Container が動くことを確認する。

---

## 0. この資料の使い方

- 上から順に操作して、**「期待される状態」と比べて OK かどうか自己判定**してください。
- 最後の **最終チェックリスト** が全部 ☑ になれば Week 3b に進める状態です。
- つまずいた項目は授業の最初に質問してください。

---

## 1. VS Code が起動するか

### 1.1 教材フォルダを VS Code で開く

ターミナルから（あるいは VS Code の「フォルダを開く」から）、Week 2 で `git clone` した `programing1` フォルダを開きます。

```bash
cd ~/<クローンした場所>/programing1
code .
```

**期待**: VS Code が起動し、左のエクスプローラに `programing1` のファイル一覧（`README.md`, `.devcontainer/`, `docs/` など）が見える。

> ❗ `code` コマンドが無い場合は、VS Code を起動して `Cmd/Ctrl + Shift + P` → **「Shell Command: Install 'code' command in PATH」** を実行。

### 1.2 必須の拡張機能

拡張機能パネル（`Cmd/Ctrl + Shift + X`）で以下が **インストール済み** になっていることを確認：

- `Python`（ms-python.python）
- `Dev Containers`（ms-vscode-remote.remote-containers）
- `Jupyter`（ms-toolsai.jupyter）

---

## 2. Docker Desktop と Dev Container が動くか

### 2.1 Docker が起動しているか

Docker Desktop のアプリを起動してから、ターミナルで：

```bash
docker --version
docker ps
```

**期待**: バージョンが表示され、`docker ps` がエラーなく表形式で返る（中身は空で OK）。

### 2.2 教材の Dev Container を開く

1. VS Code で `programing1` フォルダを開いた状態にする。
2. 左下の緑色の「><」マーク、または `Cmd/Ctrl + Shift + P` → **「Dev Containers: Reopen in Container」** を実行。
3. 初回は数分〜十数分かかる（Docker イメージのビルドと `pip install`）。

**期待**: ウィンドウ左下に **`Dev Container: Python + Unix`** と表示される。

### 2.3 コンテナの中に居ることを確認

VS Code でターミナルを開く（`` Ctrl + ` ``）→ 以下を実行：

```bash
uname -a          # Linux ... と表示される
python --version  # Python 3.12.x
```

**期待**: `uname` が **Linux** を返し、Python 3.12 系が動く。これが **コンテナの中に居る証拠** です。

---

## 3. トラブルシューティング早見表

| 症状 | 対処 |
|------|------|
| `code` コマンドが無い | VS Code のコマンドパレットから「Install 'code' command in PATH」 |
| 拡張機能が足りない | 拡張機能パネルから `Python` / `Dev Containers` / `Jupyter` を検索してインストール |
| `docker: command not found` | Docker Desktop のインストールから見直す |
| `docker ps` が `Cannot connect to the Docker daemon` | Docker Desktop アプリが起動しているか確認 |
| 「Reopen in Container」が出ない | 拡張機能 `Dev Containers` が未インストール |
| コンテナのビルドが失敗 | Docker Desktop のリソース（メモリ等）設定を増やす／再起動 |
| `uname` が Darwin を返す | コンテナの中ではなくホストで動かしている。§2.2 をやり直す |

---

## 4. 最終チェックリスト（全部 ☑ になれば Week 3b に進めます）

- [ ] VS Code で教材フォルダ `programing1` を開ける
- [ ] 拡張機能 `Python` / `Dev Containers` / `Jupyter` がインストール済み
- [ ] Docker Desktop が起動し、`docker ps` がエラーなく動く
- [ ] **Reopen in Container** でコンテナに入れ、左下に `Dev Container: Python + Unix` が出ている
- [ ] コンテナ内で `uname -a` が Linux、`python --version` が Python 3.12 系を返す

---

## 5. 次回予告

次回 **Week 3b** では、ここまで整えた環境の上で、`.py` ファイルの書き方・コロンとインデントのルール・コメントの書き方・よくあるエラーの読み方を学びます。本資料で引っかかった点があれば、Week 3b の冒頭で解消しますので遠慮なく質問してください。
