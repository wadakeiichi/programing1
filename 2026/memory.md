# プログラミングI 2026 - 作業メモ

## PDF 生成環境（reportlab）

### フォント状況
- IPAGothic / NotoSansCJK は**インストールされていない**
- 使えるのは **HeiseiKakuGo-W5**（CID フォント、JIS X 0208 のみ）のみ
- フォント登録は `register_ja_font()` が自動フォールバックする

### HeiseiKakuGo-W5 で■になる文字（使用禁止）
| 文字 | 代替 |
|------|------|
| `→` `←` などの矢印 | `->` `<-` |
| `—`（em ダッシュ U+2014） | ` - ` |
| `└─` `├─` `│` などボックス描画文字 | ASCII スペースでインデント |
| `&nbsp;`（U+00A0 非改行スペース） | 通常スペース |

### 文字化けの主な原因（毎回繰り返さないために）

#### NG1: Courier（MONO）ブロックに日本語を入れる
```python
# NG: Courier フォントで日本語 → ■■■
MP('cd ~/Documents   # Documents に移動')

# OK: コードは ASCII のみ、コメントは JP() で別セルに
MP('cd ~/Documents'), JP('# Documents に移動')
```

#### NG2: `TEXTCOLOR` を TableStyle で設定しても Paragraph には効かない
```python
# NG: TEXTCOLOR は Paragraph オブジェクトに無効
t.setStyle(TableStyle([('TEXTCOLOR', (0,0), (-1,-1), WHITE)]))
# → MP() の文字は黒のまま（暗い背景で不可視）

# OK: MP() / SC() / JP() のコンストラクタで color= を明示
MP(text, color=WHITE)   # 暗い背景に載せるとき必須
SC(text, color=WHITE)
JP(text, color=WHITE)
```

#### NG3: 日本語を含むセルに MP() を使う
```python
# NG: 'フォルダ名' 'または' など日本語混じりを MP() で → ■■■
MP('cd フォルダ名', bg=rbg)

# OK: SC() は日本語あり→JA / ASCII のみ→MONO を自動選択
SC('cd フォルダ名', bg=rbg)
```

#### NG5: ヘッダの白文字が消える（`<font>` タグが textColor を上書き）
`HC()` で `textColor=WHITE` を ParagraphStyle に設定しても、`mix()` が挿入する
`<font name="VeraBd">` タグがその色を上書きし、文字が見えなくなる。

```python
# NG: <font> タグが white を上書きして文字が消える
mix(text, bold=True)                   # -> <font name="VeraBd">Mac</font>

# OK: color='white' を明示して font タグに含める
mix(text, bold=True, color='white')    # -> <font name="VeraBd" color="white">Mac</font>
```
`HC()` 内では必ず `mix(text, bold=True, color="white")` を使う。

#### NG4: CID フォント（HeiseiKakuGo-W5）でラテン文字が重なる
HeiseiKakuGo-W5 はラテン文字のグリフメトリクスが不正確で、U/I・G/r などが重なって見える。

**対策: `mix()` 関数でASCII部分を Vera TTF でラップする**
```python
# mix(text, bold=False/True) で自動処理
# JP(), HC(), SC() 内で呼び出し済み → 追加作業不要
# ただし MP() には適用しない（Courier のまま）
```

**Vera フォントの登録（gen_pdf.py 冒頭）**
```python
_VERA_DIR = '/usr/local/lib/python3.10/dist-packages/reportlab/fonts/'
pdfmetrics.registerFont(TTFont('Vera',   _VERA_DIR + 'Vera.ttf'))
pdfmetrics.registerFont(TTFont('VeraBd', _VERA_DIR + 'VeraBd.ttf'))
registerFontFamily('Vera', normal='Vera', bold='VeraBd', italic='VeraIt', boldItalic='VeraBI')
```

### セル作成の使い分けまとめ
| 関数 | フォント | 用途 |
|------|---------|------|
| `JP(text)` | JA | 日本語テキスト（本文・ヘッダ等） |
| `MP(text)` | Courier | **ASCII のみ** のコード・パス |
| `SC(text)` | JA or MONO (自動) | 日本語＋ASCII 混在セル（コマンド表等） |
| `HC(text)` | JA | テーブルヘッダ（白文字・中央揃え） |

### 暗い背景（コードブロック等）のルール
- `code_block()` / `code_with_comment()` / `tree_table()` は背景 `#1e293b`
- 中の Paragraph には必ず `color=WHITE` を明示
- `TEXTCOLOR` は使わない（Paragraph に効かない）

---

## カリキュラム構成メモ

### 使用教材
| Week | テーマ | 使用資料 |
|------|--------|---------|
| 1 | CUI基礎（1）ターミナル・ディレクトリ・基本コマンド | `CUI実習_講義資料_Week1-2.pdf`（Week 1部分） |
| 2 | CUI基礎（2）シェルスクリプト・git clone・環境設定 | `CUI実習_講義資料_Week1-2.pdf`（Week 2部分）＋`初期設定ガイド2026ver1.key` |

### Week 1 Section 3 修正内容
- 初期ツリーから `programing2026/` を削除（まだ存在しない状態からスタート）
- `mkdir` の説明を Section 3 内に統合（ツリー構造と一緒に解説）
- mkdir 実行前→コマンド→実行後のツリー という流れに変更

### PDF 生成スクリプト
- パス: `/sessions/gracious-focused-hypatia/gen_pdf.py`
- コンテンツ: `/sessions/gracious-focused-hypatia/content.md`（テキスト・表・コード）
- 出力先: `2026/CUI実習_講義資料_Week1-2.pdf`
- 実行: `python3 gen_pdf.py`
- **編集の流れ**: `content.md` を編集 → `python3 gen_pdf.py` で PDF 再生成

### content.md の編集ルール
- `<!-- KEY -->` でセクション区切り
- 表: Markdown テーブル形式（`| 列1 | 列2 |`）
- コード: ` ```bash ... ``` ` フェンス
- 練習問題: 番号付きリスト（`1. ...`）
- ツリー: `---` で Mac / Windows を区切る
- `MP()` に日本語を入れてはいけない（Courier フォントのため ■ になる）

### 初期設定ガイド 2026 Step 5 — VS Code の準備（Keynote 追加予定）

**Step 5.1: VS Code のインストール**（2025 Step 1 の流れを踏襲）
- https://code.visualstudio.com/ からダウンロード・インストール

**Step 5.2: 日本語化**（2026 新規追加）
1. VS Code を起動
2. 拡張機能を開く（Ctrl+Shift+X / Cmd+Shift+X、またはアクティビティバーの四角アイコン）
3. 検索ボックスに `Japanese Language Pack` と入力
4. **Japanese Language Pack for Visual Studio Code**（Microsoft 製）をインストール
5. 右下に「言語を変更して再起動」ボタンが表示されたらクリック
6. VS Code が再起動し、メニューが日本語に切り替わる

**Step 5.3: 推奨拡張機能のインストール**（必要に応じて）
- Dev Containers（Microsoft 製）— Week 2 の Docker 連携に必須
- Python（Microsoft 製）

**Week 2 資料との対応（日本語 UI 前提）**
| 英語メニュー（旧） | 日本語メニュー（日本語化後） |
|-------------------|---------------------------|
| File -> Open Folder... | ファイル -> フォルダーを開く... |
| Terminal -> New Terminal | ターミナル -> 新しいターミナル |
| Reopen in Container | コンテナーで再度開く |
| Extensions | 拡張機能 |
