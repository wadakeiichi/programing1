# CUI実習_講義資料 Week1-2  コンテンツファイル
#
# ルール:
#   <!-- KEY --> の行がセクション区切り。次の <!-- まですべてそのキーの内容。
#   テキスト    : そのまま JP() に渡す（<b>太字</b> OK）
#   表          : Markdown テーブル形式（ヘッダ行 + 区切り行 + データ行）
#   コードブロック : ```lang ... ``` フェンス形式
#   コード+コメント : | で cmd と comment を分けた行リスト（code_with_comment 用）
#   ツリー      : --- で Mac/Windows を区切る（tree_table 用）
#   練習問題    : 番号付きリスト（1. 〜 の形式）
#   注意ボックス: 通常テキスト（note_box に渡す）

<!-- W1_BANNER -->
Week 1  CUI基礎実習（1） - ターミナル・ディレクトリ・基本コマンド

<!-- W1_SEC1_INTRO -->
GUI（Graphical User Interface）はマウスやタップで操作するインターフェース（Windows/Finderなど）。CUI（Character User Interface）はキーボードでコマンド（命令文）を入力して操作する方式。

<!-- W1_SEC1_TABLE -->
| | GUI | CUI |
|--|-----|-----|
| 操作方法 | マウスでクリック・ドラッグ | キーボードでコマンド入力 |
| 代表例 | Windowsエクスプローラー、Finder | ターミナル、PowerShell、bash |
| 得意なこと | 直感的・視覚的な操作 | 繰り返し処理、プログラムの実行、自動化 |
| プログラム開発 | 限定的 | ほぼ必須（コンパイル、実行、git など） |

<!-- W1_SEC1_BODY2 -->
プログラミングでは、プログラムを実行したり Git を使ったりするために CUI の操作が必須になる。Dev Container（Docker）も CUI から起動する。

<!-- W1_SEC2_MAC -->
1   キーボードで Command + Space を押す
2   「ターミナル」と入力 -> Enter
3   黒または白のウィンドウが開いたら成功
(Finder -> アプリケーション -> ユーティリティ -> ターミナル)

<!-- W1_SEC2_WIN -->
1   スタートメニュー（左下の Windows マーク）をクリック
2   「PowerShell」と入力 -> Enter
3   青いウィンドウが開いたら成功
(Win + R -> powershell -> Enter でも起動できる)

<!-- W1_SEC2_PROMPT_INTRO -->
起動すると「入力待ち」の記号（プロンプト）が表示される。

<!-- W1_SEC2_NOTE -->
「$」「%」「>」はプロンプト（入力待ちの印）なので入力しない！
例：資料に $ cd Documents と書いてあっても、入力するのは cd Documents だけ。

<!-- W1_SEC2_PRACTICE -->
1. ターミナル（Mac）またはPowerShell（Windows）を起動して、表示されたプロンプトをノートに書き写そう。
2. 次のコマンドを実行してみよう：pwd（現在のディレクトリが表示される）
3. 「$ cd Documents」と書かれた場合、実際に入力するコマンドは何か答えよ。

<!-- W1_SEC3_INTRO -->
ファイルシステムは木構造（ツリー）になっている。「フォルダ」と「ディレクトリ」は同じ意味。

<!-- W1_SEC3_DIAGRAM_CAPTION -->
↑ 各フォルダが親子関係でつながっている。programing2026/ は mkdir コマンドで自分で作成するフォルダ。

<!-- W1_SEC3_TREE_BEFORE -->
/                   <- root
  Users/
    wada/        <- home directory (~)
      Documents/
      Desktop/
---
C:\                 <- root
  Users\
    wada\        <- home directory (~)
      Documents\
      Desktop\

<!-- W1_SEC3_HOME_NOTE -->
「~」はホームディレクトリ（自分のユーザーフォルダ）を表す省略記号。

<!-- W1_SEC3_MKDIR_INTRO -->
mkdir（make directory）コマンドで新しいフォルダを作成できる。授業用フォルダ programing2026 を Documents の中に作ろう。

<!-- W1_SEC3_MKDIR_CODE -->
cd ~/Documents | # Documents に移動
mkdir programing2026 | # フォルダを新規作成
ls | # 一覧で確認

<!-- W1_SEC3_TREE_AFTER -->
/                        <- root
  Users/
    wada/
      Documents/
        programing2026/  <- created!
      Desktop/
---
C:\                      <- root
  Users\
    wada\
      Documents\
        programing2026\  <- created!
      Desktop\

<!-- W1_SEC3_TERMS_TABLE -->
| 用語 | 説明 |
|------|------|
| ホームディレクトリ | 自分のユーザーフォルダ（~ と省略可）  Mac: /Users/wada  Win: C:\Users\wada |
| カレントディレクトリ | 今いる場所。コマンドはここを基準に動く |
| パス区切り文字 | Mac: /（スラッシュ）  Win: \（バックスラッシュ）  ※PowerShellは/も可 |

<!-- W1_SEC3_YEN_NOTE -->
Windows 日本語環境では \（バックスラッシュ）が ¥（円マーク）として表示される場合がある。見た目は違うが同じキー・同じ意味。パスを入力するときは ¥ キーで \ として扱われる。

<!-- W1_SEC3_PATH_TABLE -->
| 種類 | Mac の例 | Windows の例 |
|------|----------|-------------|
| 絶対パス（ルートから全部） | /Users/wada/Documents/programing2026 | C:\Users\wada\Documents\programing2026 |
| 相対パス（今が Documents の場合） | programing2026 または ./programing2026 | programing2026 または .\programing2026 |
| 一つ上のフォルダ | .. | .. |
| ホームから | ~/Documents/programing2026 | ~\Documents\programing2026 |

<!-- W1_SEC3_PRACTICE -->
1. pwd コマンドで現在地を確認し、表示されたパスをノートに書き写そう。
2. ls コマンドでホームのファイル・フォルダ一覧を確認しよう。
3. cd Documents で移動 -> mkdir programing2026 でフォルダを作成 -> ls で確認しよう。
4. cd programing2026 で移動 -> pwd で絶対パスを確認 -> ノートに書き写そう。
5. cd .. で一つ上に戻る -> pwd で元の場所に戻ったか確認しよう。
6. ホームディレクトリから programing2026 への絶対パスを書いてみよう（Mac/Win 両方）。

<!-- W1_SEC4_INTRO -->
MacとWindows(PowerShell)でコマンド名はほぼ共通。ただしオプション（フラグ）の書き方が異なることがある。

<!-- W1_SEC4_CMD_TABLE -->
| 操作 | Mac (zsh) | Windows (PowerShell) | 備考 |
|------|-----------|---------------------|------|
| 現在地を表示 | pwd | pwd | 共通 |
| ファイル一覧 | ls | ls | 共通 |
| ディレクトリ移動 | cd フォルダ名 | cd フォルダ名 | 共通 |
| 一つ上へ移動 | cd .. | cd .. | 共通 |
| ホームへ移動 | cd ~ または cd | cd ~ | 共通 |
| フォルダ作成 | mkdir 名前 | mkdir 名前 | 共通 |
| ネスト作成 | mkdir -p a/b/c | mkdir a\b\c | オプションが違う |
| ファイルコピー | cp 元 先 | cp 元 先 | 共通 |
| 移動・改名 | mv 元 先 | mv 元 先 | 共通 |
| ファイル削除 | rm ファイル名 | rm ファイル名 | ゴミ箱に入らない！ |
| テキスト表示 | cat ファイル名 | cat ファイル名 | 共通 |
| 画面クリア | clear | cls または clear | 少し違う |

<!-- W1_SEC4_PRACTICE -->
1. pwd でホームにいることを確認しよう。
2. cd Documents で Documents に移動しよう。
3. mkdir programing2026 でフォルダを作成（既存なら ls で確認）しよう。
4. cd programing2026 で移動 -> pwd でパスを確認しよう。
5. cd .. で一つ上に戻る -> pwd で確認しよう。
6. ホームから programing2026 への絶対パスを Mac / Windows 両方で書いてみよう。

<!-- W1_FOOTER -->
プログラミングI 2026  Week 1 講義資料 - 次回（Week 2）: VS Code の基本操作・シェルスクリプト・git clone・Dev Container

<!-- W2_BANNER -->
Week 2  CUI基礎実習（2） - VS Code・Dev Container・シェルスクリプト

<!-- W2_PREP_BOX -->
別途配布の 「初期設定ガイド 2026」 に従って環境設定を先に済ませて、指示のあるところまで設定できたら、この資料に戻って Section 1 に進みます。

<!-- W2_SEC1_INTRO -->
VS Code（Visual Studio Code）はコード編集・実行を一画面で行える無料のエディタ。ターミナルも内蔵しており、この授業ではメインのツールとして使う。

<!-- W2_SEC1_AREAS_TABLE -->
| エリア | 場所 | 役割 |
|--------|------|------|
| アクティビティバー | 一番左の縦列アイコン | エクスプローラー・検索・拡張機能などを切り替え |
| エクスプローラー（サイドバー） | 左のファイルツリー | フォルダ・ファイルの一覧。クリックで開く |
| エディタ | 右上の大きな領域 | コードを書く・編集するメインの場所 |
| ターミナル | 右下（エディタの下） | コマンドを入力・実行するシェル。VS Code 内で動く |

<!-- W2_SEC1_TERM_TABLE -->
| 方法 | 操作 |
|------|------|
| メニューから | ターミナル(T)  ->  新しいターミナル |
| ショートカット（Mac） | Ctrl + `（バッククォート） |
| ショートカット（Windows） | Ctrl + @  または  Ctrl + ` |

<!-- W2_SEC1_TERM_NOTE -->
ターミナルを開くと、VS Code が開いているフォルダの中がカレントディレクトリになっている。Week 1 で学んだ cd・ls・pwd などのコマンドがそのまま使える。

<!-- W2_SEC1_FOLDER_TABLE -->
| 手順 | 操作 |
|------|------|
| 1. フォルダを選択 | ファイル(F) -> フォルダーを開く...  ->  programing2026 フォルダを選択 |
| 2. ターミナルを開く | ターミナル(T) -> 新しいターミナル  （カレントは programing2026/） |
| 3. 動作確認 | ls を実行してフォルダ内のファイル一覧が表示されることを確認 |

<!-- W2_SEC1_FILEOPS_TABLE -->
| 操作 | エクスプローラー（右クリック） | キーボード |
|------|-------------------------------|-----------|
| 新規フォルダを作る | 右クリック -> 新しいフォルダ... | エクスプローラー上部アイコン |
| 新規ファイルを作る | 右クリック -> 新しいファイル... | エクスプローラー上部アイコン |
| ファイルを保存する | ファイル(F) -> 保存 | Cmd+S（Mac） / Ctrl+S（Win） |
| ファイルを削除する | 右クリック -> 削除 | Delete キー |
| ファイル名を変更 | 右クリック -> 名前の変更 | F2 キー |

<!-- W2_SEC1_SAVE_NOTE -->
未保存のファイルはタブに白丸「・」が表示される。Cmd+S（Mac）/ Ctrl+S（Windows）で上書き保存。保存し忘れに注意しよう。

<!-- W2_SEC1_MD_INTRO -->
Markdown は「#」「-」「**」などの記号でテキストに見出しや箇条書きを付ける軽量な記法。拡張子は .md。GitHub・Notion・Slack など多くのツールで使われる。

<!-- W2_SEC1_MD_TABLE -->
| 要素 | 書き方 | 表示イメージ |
|------|--------|-------------|
| 見出し1 | # タイトル | 一番大きな見出し |
| 見出し2 | ## 小見出し | 次に大きな見出し |
| 箇条書き | - 項目名 | ・箇条書き |
| 太字 | **テキスト** | テキスト（太字） |
| イタリック | *テキスト* | テキスト（斜体） |
| インラインコード | `code` | コード表示 |

<!-- W2_SEC1_MD_SAMPLE -->
```markdown
# 自己紹介

## 名前
wada

## 好きなこと
- プログラミング
- **コーヒー**

## 一言コメント
`python` でプログラムを作ることが好きです。
```

<!-- W2_SEC1_PREVIEW_TABLE -->
| 方法 | Mac | Windows |
|------|-----|---------|
| 横に並べて開く（推奨） | Cmd+K -> V | Ctrl+K -> V |
| 別タブで開く | Cmd+Shift+V | Ctrl+Shift+V |
| アイコン | エディタ右上「プレビューを横に表示」アイコン | （同左） |

<!-- W2_SEC1_PRACTICE -->
1. VS Code を起動し、programing2026 フォルダを開こう（ファイル(F) -> フォルダーを開く...）。
2. エクスプローラーで week2 という新規フォルダを作成しよう（右クリック -> 新しいフォルダ...）。
3. week2 フォルダ内に test.md という新規ファイルを作成しよう（右クリック -> 新しいファイル...）。
4. test.md に「Markdown サンプル」と同じ内容を書いて、Cmd+S（Mac）/ Ctrl+S（Windows）で保存しよう。
5. プレビューを開いて（Cmd+Shift+V）、見出し・箇条書き・太字が正しく表示されることを確認しよう。
6. ターミナルを開いて cd week2 で移動し、cp test.md test_copy.md でファイルをコピーしよう。
7. エクスプローラーで test_copy.md を右クリックし削除しよう。ls でファイルが消えたことを確認しよう。

<!-- W2_DEVCONTAINER_BOX -->
練習問題 1 が終わったら、「初期設定ガイド 2026」に戻って <b>Docker のインストールと Dev Container の起動</b> の手順を実施してください。Dev Container 内のターミナルに bash プロンプト($) が表示されたら、Section 2 に進みます。

<!-- W2_SEC2_INTRO -->
シェルとは、ユーザーが入力したコマンドを解釈・実行するプログラム。OSとユーザーをつなぐ「外殻（shell）」として機能する。ここからは <b>Dev Container（Linux）内のターミナル</b> で実習を進める。

<!-- W2_SEC2_TABLE -->
| シェル | 主な環境 | 特徴 |
|--------|----------|------|
| bash | Linux、Dev Container内 | 最も広く使われる。シェルスクリプトの標準的存在 |
| zsh | macOS（10.15以降） | bashと互換性が高い。補完機能が強力 |
| PowerShell | Windows | .NETベース。bashと文法は異なる |

<!-- W2_SEC2_NOTE -->
Dev Container（Docker）の中は Linux 環境なので bash が使われる。この授業でのシェルスクリプトは bash で学ぶ。

<!-- W2_SEC2_PRACTICE -->
1. Dev Container のターミナルで echo $SHELL を実行し、/bin/bash と表示されることを確認しよう。
2. bash --version でバージョンを確認し、ノートに記録しよう。
3. Mac のネイティブターミナル（zsh）と Dev Container（bash）の違いを自分の言葉で説明せよ。

<!-- W2_SEC3_INTRO -->
シェルスクリプトは、コマンドをテキストファイルに書いて一括実行するもの。拡張子は .sh

<!-- W2_SEC3_21_CODE -->
```bash
#!/bin/bash
# hello.sh
echo "Hello, World!"
```

<!-- W2_SEC3_21_BODY -->
1行目の #!/bin/bash は shebang（シバン）と呼ばれ、このスクリプトを bash で実行することを OS に伝える。1行目に必ず書く。
# で始まる行はコメント（実行されない説明文）。

<!-- W2_SEC3_22_CODE -->
```bash
#!/bin/bash
name="Alice"
echo "Hello, $name!"
echo "Hello, ${name}!"
```

<!-- W2_SEC3_22_BODY -->
変数に代入するには name="Alice" と書く。値を参照するときは $name または ${name} と書く。

<!-- W2_SEC3_22_NOTE -->
= の前後にスペースを入れない！ name = "Alice" はエラー。name="Alice" が正しい。

<!-- W2_SEC3_23_CODE -->
```bash
#!/bin/bash
# greet.sh
echo "Hello, $1!"
echo "Args: $#"
```

<!-- W2_SEC3_23_BODY -->
$1 は第1引数、$2 は第2引数、$# は引数の個数を表す。
実行例：./greet.sh Wada  ->  Hello, Wada!

<!-- W2_SEC3_24_CODE -->
```bash
#!/bin/bash
# check.sh
if [ $# -eq 0 ]; then
    echo "Usage: ./check.sh <name>"
    exit 1
fi
echo "Hello, $1!"
```

<!-- W2_SEC3_24_BODY -->
[ ... ] の中に条件を書く。-eq（等しい）、-ne（等しくない）、-lt（より小さい）などが使える。

<!-- W2_SEC3_25_CODE -->
```bash
#!/bin/bash
# loop.sh
for i in 1 2 3 4 5; do
    echo "Number: $i"
done

# seq: generate a sequence
for i in $(seq 1 10); do
    echo "i = $i"
done
```

<!-- W2_SEC3_EXAMPLE_CODE -->
```bash
#!/bin/bash
# example.sh
for f in *.txt; do
    echo $f
done
```

<!-- W2_SEC3_PRACTICE -->
1. 上のスクリプト example.sh は何をするか説明せよ。
2. 変数 x に "physics" を代入して "I love physics" と出力するスクリプトを書け。
3. 引数が 0 個のときに「引数を入力してください」と表示し、終了するスクリプトを書け。
4. ループを使って 1 から 5 まで順番に "Number: 1" のように出力するスクリプトを書け。

<!-- W2_SEC4_31_BODY -->
Dev Container 内で VSCode のエディタを使って .sh ファイルを作成する。または nano コマンドでターミナル内から編集できる。

<!-- W2_SEC4_31_CODE -->
```bash
nano hello.sh   # open / create file in nano editor
# Ctrl+O: save   Ctrl+X: quit
```

<!-- W2_SEC4_32_CODE -->
```bash
chmod +x hello.sh   # grant execute permission
ls -l hello.sh      # check: should show -rwxr-xr-x (x flag)
```

<!-- W2_SEC4_32_BODY -->
chmod +x はファイルに「実行可能」フラグを立てるコマンド。これをしないと「Permission denied」エラーになる。

<!-- W2_SEC4_33_CODE -->
```bash
./hello.sh              # ./ means current directory
./greet.sh Wada         # pass arguments after the script name
bash hello.sh           # another way: run directly with bash
```

<!-- W2_SEC4_PRACTICE -->
1. "Hello, World!" と出力する hello.sh を作成し、実行しよう。
2. 引数で名前を受け取り "Hello, [名前]!" と表示する greet.sh を作成し、動作確認しよう。
3. 1 から 5 まで順に番号を出力する loop.sh を作成して実行しよう。

<!-- W2_SEC5_INTRO -->
授業で使うリポジトリを取得して、Python 実行環境（Dev Container）を起動するまでの手順。

<!-- W2_SEC5_TABLE -->
| # | コマンド / 操作 | 説明 |
|---|-----------------|------|
| 1 | cd ~/Documents/programing2026 | Week 1 で作った授業フォルダへ移動 |
| 2 | git clone https://github.com/wada-keiichi/programing1.git | リポジトリをダウンロード（初回のみ） |
| 3 | ls | programing1 フォルダが生成されたか確認 |
| 4 | VSCode で programing1 フォルダを開く | ファイル -> フォルダーを開く... -> programing1 を選択 |
| 5 | Dev Container を起動 | 画面左下の青い "><" アイコン -> "コンテナーで再度開く" を選択 |
| 6 | ターミナルを開く（VSCode 内） | ターミナル -> 新しいターミナル（bash プロンプトが表示される） |

<!-- W2_SEC5_NOTE -->
Dev Container が起動するとき Docker が動いている必要がある。Docker Desktop が起動していない場合は先に起動しておくこと。

<!-- W2_SEC5_PRACTICE -->
1. cd コマンドで ~/Documents/programing2026 へ移動しよう。
2. git clone コマンドでリポジトリをダウンロードしよう。
3. ls コマンドで programing1 フォルダが作られたか確認しよう。
4. VSCode で programing1 フォルダを開き、Dev Container を起動しよう。
5. Dev Container 内のターミナルで echo $SHELL を実行し、/bin/bash であることを確認しよう。
6. hello.sh を Dev Container 内に作成して実行してみよう。

<!-- W2_FOOTER -->
プログラミングI 2026  Week 2 講義資料 - git clone・Dev Container の手順は「初期設定ガイド 2026」を参照
