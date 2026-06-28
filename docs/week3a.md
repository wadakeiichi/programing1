# Week 3a — 環境設定チェック（Week 1〜2 の確認）

**対象**: プログラミング I 受講生
**目的**: 初期設定のあと、　Week 3b（Python の書き方のルール）に進む前に、設定したはずの VS Code と Dev Container が動くことを確認する。

> **🐳 授業を始める前に — Dev Container が起動しているか必ず確認すること**
>
> 毎回多くの学生が **Docker Desktop を起動し忘れている／Dev Container に入っていない** 状態で授業を始めてつまずきます。この確認を始める前に、以下 3 点を **上から順に** 確認してください。
>
> **① Docker Desktop が起動しているか**
>
> - 🪟 Windows: 通知領域（タスクバー右下、`^` をクリックして表示）に **クジラのアイコン 🐳** が出ているか
> - 🍎 macOS: メニューバー右上に **クジラのアイコン 🐳** が出ているか
> - 出ていない場合 → スタート／Launchpad から **Docker Desktop を起動** → クジラが「Docker Desktop is running」状態になるまで **1〜2 分待つ**
>
> **② VS Code が Dev Container の中で動いているか**
>
> VS Code の **左下の青／緑の表示** を見る：
>
> - ✅ **「開発コンテナー: Python3@desktop-linux」** のような表示 → OK
> - ❌ `><` マークだけ／何も出ていない → 左下の `><` をクリック → **「コンテナーで再度開く」** を選ぶ（初回は数分かかる）
>
> **③ ターミナルのプロンプトが Linux になっているか**
>
> VS Code のターミナル（`` Ctrl + ` `` または `Ctrl + @`）を開き、プロンプトを確認：
>
> ```
> vscode ➜ /workspaces/programing1_student (main) $   ← ✅ Dev Container の中
> ```
>
> `PS C:\Users\...>`（Windows PowerShell）や `wada@MacBook ~ %`（Mac のターミナル）のような表示は **Dev Container の外** にいるサイン。② に戻ってやり直すこと。
>
> 上記いずれかでつまずいたら、`初期設定ガイド2027.md` の Step 8 〜 Step 10 を参照。

---

## 0. この資料の使い方

- 上から順に操作して、**「期待される状態」と比べて OK かどうか自己判定**してください。
- 最後の **最終チェックリスト** が全部 ☑ になれば Week 3b に進める状態です。
- つまずいた項目は授業の最初に質問してください。

---

## 1. VS Code が起動するか

### 1.1 授業用フォルダ(programing1)を VS Code で開く


**期待**: VS Code が起動し、左のエクスプローラに `programing1` のファイル一覧（`README.md`, `.devcontainer/`, `docs/` など）が見える。

### 1.2 必須の拡張機能

拡張機能パネル (左の積み木みたいなアイコン）（もしくは　`cntl + Shift + X` (win)`⌘ + Shift + X` (mac)）で以下が **インストール済み** になっていることを確認：

- `Python`（ms-python.python）
- `Dev Containers`（ms-vscode-remote.remote-containers）
- `Jupyter`（ms-toolsai.jupyter）

---

## 2. Docker Desktop と Dev Container が動くか

### 2.1 Docker が起動しているか

まずは **Docker Desktop のアプリ本体を起動** します。OS ごとの手順は次の通りです。

#### macOS の場合

1. Launchpad（または「アプリケーション」フォルダ）から **Docker** アイコンをクリックして起動。
2. メニューバー右上（時計の近く）に **クジラのアイコン 🐳** が出ることを確認。
3. macOS の標準「ターミナル」を開いて、以下を実行:

```bash
docker -v
docker ps
```

#### Windows の場合

1. スタートメニューから **「Docker Desktop」** を起動（または既にインストール済みなら自動起動している場合あり）。
2. タスクトレイ（画面右下の△マークの中）に **クジラのアイコン 🐳** が出るまで待つ（初回は 30 秒〜1 分）。
3. **PowerShell**（または Windows Terminal）を開いて、以下を実行:

```powershell
docker -v
docker ps
```

#### 期待される出力（macOS / Windows 共通）

```
Docker version 27.x.x, ...
CONTAINER ID   IMAGE   COMMAND   ...
```

**期待**: `docker -v` でバージョンが表示され、`docker ps` がエラーなく表形式のヘッダを返す（中身は空でも OK）。

> ❗ `Cannot connect to the Docker daemon` と出たら、**Docker Desktop のアプリがまだ起動していない／起動中** です。クジラのアイコンが「running」になるまで 1 分ほど待ってからもう一度試してください。
> ❗ **WSL 2 が必要**: Windows の初回起動時に WSL 2 のインストールを促されたら指示に従ってください。WSL 2 が未設定だと Docker は起動しません。
> ❗ **Apple Silicon（M1/M2/M3）Mac** の場合、初回起動時に「Rosetta を使用する」の設定が必要になるケースあり。ダイアログに従ってください。

### 2.2 教材の Dev Container を開く

1. VS Code で `programing1` フォルダを開いた状態にする。
2. 左下の緑色の「><」マーク、または `Cmd/Ctrl + Shift + P` → **「Dev Containers: Reopen in Container」** (日本語だと、**開発コンテナーを再起動**）を実行。
3. 初回は数分〜十数分かかる（Docker イメージのビルドと `pip install`）。

**期待**: ウィンドウ左下に **`Dev Container: Python + Unix`** と表示される。

### 2.3 コンテナの中に居ることを確認

VS Code でターミナルを開く（`` Ctrl + ` ``）→ 以下を実行 (**--version は、ハイフン２つ**）：

```bash
uname -a          # Linux ... と表示される
python --version  # Python 3.12.x
```

**期待**: `uname` が **Linux** を返し、Python 3.12 系が動く。これが **コンテナの中に居る証拠** です。

---

## 3. 環境・教材の更新（`make` コマンド）

Week 3b 以降、毎回の授業で **新しい教材（`docs/` に `week4.md`, `week5.md`, …）や `.devcontainer` の設定** が追加・更新されていきます。**各授業の開始時**（および気づいたとき）に、必ず以下の操作をしてください。

### 3.1 更新方法

VS Code の **開発コンテナー の中** でターミナルを開き（`` Ctrl + ` ``）、`programing1` フォルダで次のコマンドを打つだけです。

```bash
make
```

これだけで、教員用リポジトリの最新版が手元にコピーされます。具体的には:

- `docs/` に新しい週の教材（`week4.md` など）が追加される
- `.devcontainer/` が更新されたときは自動で取得される（必要ならリビルド案内が出ます）
- `.github/` `.vscode/` `makefile` `README.md` なども同時に最新化される

### 3.2 実行時のメッセージ例

```
🌀 教員用リポジトリから最新の教材を取得します...
🌐 リモートの接続を確認中...
✅ 接続成功：更新を実行します
📥 取得: .devcontainer
📥 取得: docs
...
✅ 完了しました！教員用リポジトリで上書きされました。
   docs/ に新しい教材（例: week3a.md など）が入っていないか確認してください。
```

### 3.3 注意

- **学生が自分で作った `.py` ファイル等は削除されません。** `make` が上書きするのは教員が配布しているファイル（`docs/` や `.devcontainer/` など）だけです。
- 一方、**教員配布ファイル（例: `docs/*.md`）を自分で書き換えてしまった場合は、`make` で上書きされて消えます。** 書き込みたいメモは別のフォルダ（例: 自分用の `notes/`）に書くようにしてください。
- `ℹ️ .devcontainer に変更がありました` と出たときは、左下の「><」マーク → **「コンテナーのリビルド」** を実行してください。
- ネットワークに繋がらないときは更新はスキップされます（授業後にもう一度 `make` を打ってください）。

> 💡 毎回の授業で最初に `make` を打つ、を習慣にしましょう。

---

## 4. 次回予告

次回 **Week 3b** では、ここまで整えた環境の上で、`.py` ファイルの書き方・コロンとインデントのルール・コメントの書き方・よくあるエラーの読み方を学びます。本資料で引っかかった点があれば、Week 3b の冒頭で解消しますので遠慮なく質問してください。

Week 3b の教材（`docs/week3b.md`）は、次回までに `make` を打てば手元に届きます。
