# Week 9　pandas によるデータ解析

> **🐳 授業を始める前に — Dev Container が起動しているか必ず確認すること**
>
> 毎回多くの学生が **Docker Desktop を起動し忘れている／Dev Container に入っていない** 状態で授業を始めてつまずきます。`make` を打つ前に、以下 3 点を **上から順に** 確認してください。
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
> ① と ② が揃っていない状態で `make` を打っても **絶対に動きません**。授業当日にここでつまずくと進行に遅れます。`初期設定ガイド2027.md` の Step 8 〜 Step 10 を見直してください。

---

授業を始める前に、前回の授業で環境設定した **dev container 環境下** で `make` を実行し、授業資料フォルダ `docs` を更新しておくこと。

> **重要**: ここで使うのは **VS Code のターミナル** であり、**Mac の「ターミナル」アプリや Windows の PowerShell／コマンドプロンプトではない**。間違えないように注意すること。VS Code のターミナルで dev container に正しく入っていれば、プロンプトは次のようになっているはず：
>
> ```
> vscode ➜ /workspaces/programing1_student (main) $
> ```
>
> もしプロンプトが上のようになっていない（例：`wada@MacBook ~ %` や `PS C:\Users\...>` など）場合は、ターミナルを開く場所・環境を間違えているので、下記の手順で開き直すこと。

#### VS Code のターミナルが見えない／出ていない場合

画面下部にターミナルが表示されていない学生は、以下のいずれかの方法で開く：

- **キーボードショートカット**: `Ctrl + ` ` （バッククォート、Mac でも Windows でも共通）でターミナルパネルを開閉できる
- **コマンドパレットから**: `Cmd + Shift + P`（Mac）／`Ctrl + Shift + P`（Windows）でコマンドパレットを開き、`ターミナル` または `Terminal: Create New Terminal` と入力して Enter
- **メニューから**: 上部メニューの `表示 (View)` → `ターミナル (Terminal)` を選択

ターミナルが開いたら、プロンプトが `vscode ➜ /workspaces/programing1_student (main) $` になっていることを確認した上で、

```bash
make
```

と入力して Enter キーを押し、`docs` フォルダを最新版に更新する。更新が終わったら、自分の環境下に **`docs/week9.md` が存在すること** を必ず確認すること。

```bash
ls docs/week9.md
```

#### 自分の作業ファイル `week9.py` を作る

`docs` の更新が確認できたら、**授業用フォルダ（自分の作業フォルダ）の下** に `week9.py` という新しいファイルを作成する。今週も、解説中の **グレイ背景の Python コード** や 例題部分を、この `week9.py` に **`# %%` 記法** で書き写しながら動作を試していく。

```python
# %%
# セル1：pandas で表（DataFrame）を作って表示する
import pandas as pd
df = pd.DataFrame({
    "name":   ["Sun", "Sirius", "Betelgeuse"],
    "temp_K": [5800, 9940, 3500],
})
print(df)

# %%
# セル2：条件で絞り込む
hot = df[df["temp_K"] > 6000]
print(hot)
```

> **注意**: ファイル `stars.csv` を `pd.read_csv` で読み込む例は **例 1 以降** に出てくる。`stars.csv` は例 1 を実行して初めて作られるので、それより前に `pd.read_csv("stars.csv")` を実行すると `FileNotFoundError` になる。上の導入セルのように、まずは **辞書から作った DataFrame** で pandas の操作に慣れること。

> **指示**: 以降のグレイ背景のコードは、**そのまま読むだけでなく、必ず `week9.py` に `# %%` で区切りながら入力して動作を確認すること**。例題部分も同様に、自分で入力して試すこと。コピペではなく **自分の手で打ち込む** ことで身につく。

---

### 今週のテーマ ― 表データを「列」で考える

Week 8 では `np.loadtxt` で数値だけの表を読み込んだ。これは便利だが、**列に名前が付かない**（`data[:, 0]` のように番号で扱う）ため、列が増えると分かりにくい。

今週使う **pandas** は、**列に名前の付いた表（テーブル）** を扱うライブラリで、観測データ・実験データの解析で広く使われる。「気温の列」「質量の列」のように **名前で列を指定** でき、条件での絞り込みや統計量の計算も 1 行で書ける。Excel の表を Python で扱うイメージに近い。

| やること | pandas の書き方 |
|---------|----------------|
| CSV を読む | `pd.read_csv("file.csv")` |
| 中身を覗く | `df.head()` / `df.shape` / `df.columns` |
| 列を取り出す | `df["列名"]` |
| 統計量 | `df["列名"].mean()` / `df.describe()` |
| 条件で絞る | `df[df["列名"] > 値]` |
| 新しい列を作る | `df["新列"] = 式` |

---

### 文法解説

#### DataFrame ― pandas の表

pandas の表は **DataFrame（データフレーム）** というオブジェクトで表される。慣習として `import pandas as pd` と書く。まずは Python の辞書（Week 8）から DataFrame を作ってみる。

```python
import pandas as pd

data = {
    "name":   ["Sun", "Sirius", "Betelgeuse"],
    "temp_K": [5800, 9940, 3500],
    "mass":   [1.0, 2.06, 16.5],   # 太陽質量単位
}
df = pd.DataFrame(data)
print(df)
```

表示すると、**行（各天体）** と **名前付きの列** からなる表になっている。いちばん左の `0, 1, 2` は **インデックス（行番号）**。

#### CSV ファイルを読み込む ― pd.read_csv

実際のデータは CSV ファイルで配られることが多い。**`pd.read_csv`** は、先頭行を **列名（見出し）** として自動で認識し、DataFrame にして読み込む。

```python
df = pd.read_csv("stars.csv")
```

Week 8 の `np.loadtxt` と違い、`skiprows` や `delimiter` を指定しなくても、見出し付き CSV をそのまま読める。文字列の列（天体名など）が混ざっていても扱える点も `np.loadtxt` との大きな違い。

#### 中身を確認する ― head / shape / columns / dtypes

読み込んだら、まず中身を確認する習慣をつける。

```python
print(df.head())     # 先頭 5 行だけ表示（大きな表の確認に便利）
print(df.shape)      # (行数, 列数) のタプル
print(df.columns)    # 列名の一覧
print(df.dtypes)     # 各列の型（数値か文字列かなど）
print(df.describe()) # 数値列の統計量（件数・平均・最小・最大など）をまとめて表示
```

> **ポイント**: `df.describe()` は **平均・標準偏差・最小・最大・四分位数** を全数値列について一度に出す。データを受け取ったらまず `head()` と `describe()` で全体像をつかむとよい。

#### 列を取り出す ― df["列名"]

**列名を `[]` に入れる** と、その列を取り出せる（辞書に似た書き方）。取り出した 1 列は **Series（シリーズ）** という 1 次元のデータ。

```python
print(df["temp_K"])          # temp_K 列だけ
print(df["temp_K"].mean())   # 平均
print(df["temp_K"].max())    # 最大
print(df["temp_K"].min())    # 最小
```

複数の列がほしいときは、**列名のリスト** を渡す（`[]` が二重になることに注意）。

```python
print(df[["name", "temp_K"]])   # name と temp_K の 2 列
```

#### 条件で行を絞り込む ― ブールインデックス

データ解析でいちばん使うのが **条件による絞り込み**。`df["列名"] > 値` は各行について真偽（True/False）を並べた Series を返し、それを `df[...]` に入れると **条件が True の行だけ** が取り出される。

```python
hot = df[df["temp_K"] > 6000]      # 表面温度が 6000 K より高い天体
print(hot)
```

複数条件は `&`（かつ）・`|`（または）でつなぐ。**各条件を `()` で囲む** こと（Python の `and`/`or` ではなく `&`/`|` を使う点に注意）。

```python
mid = df[(df["temp_K"] >= 5000) & (df["temp_K"] < 8000)]
print(mid)
```

#### 新しい列を作る ― df["新列"] = 式

既存の列から計算した結果を、**新しい列** として追加できる。列どうしの演算は NumPy と同様に **要素ごと** に行われる（Week 5 のブロードキャスト）。

```python
# 質量と半径から平均密度を作る（例として半径列があるとする）
df["lum_approx"] = df["mass"] ** 3.5   # 主系列星の質量・光度関係 L ∝ M^3.5
print(df[["name", "mass", "lum_approx"]])
```

#### NumPy・Matplotlib とつなぐ

pandas の列（Series）は **`.values` または `np.array(...)`** で NumPy 配列に変換でき、これまで学んだ NumPy・Matplotlib（Week 5・6）とそのまま組み合わせられる。

```python
import numpy as np
import matplotlib.pyplot as plt

x = df["temp_K"].values        # NumPy 配列として取り出す
y = np.array(df["mass"])

plt.scatter(x, y)
plt.xlabel("temperature [K]")
plt.ylabel("mass [solar]")
plt.savefig("scatter.png")
```

> **ポイント**: `np.loadtxt`（Week 8）が「数値だけの表」向きなのに対し、pandas は **文字列と数値が混ざった表**・**見出し付きの表**・**欠損値のある表** を柔軟に扱える。本格的なデータ解析では pandas が主役になる。

---

### 例 1 ― 恒星カタログを読み込んで絞り込む

恒星のカタログを CSV として作り、pandas で読み込んで「高温の星だけ」を絞り込み、統計量を確認する。**まず CSV を用意し、それを `pd.read_csv` で読む** という実データ解析の流れを体験する。

> **⚠ 必ず最初にこの例 1 を実行すること**: この例 1 が `stars.csv` を作る。**例 2 と練習問題 6 はこの `stars.csv` を読み込むので、例 1 を実行していないと `FileNotFoundError` で動かない**。授業を始めるときも、まず例 1 のセルを実行して `stars.csv` を作ってから先に進むこと。

```python
# week9_ex1.py
import pandas as pd

# --- カタログ CSV を用意する（本来は配布されるデータ）---
catalog = """name,temp_K,mass,radius
Sun,5800,1.00,1.00
Sirius,9940,2.06,1.71
Betelgeuse,3500,16.5,764
Proxima,3040,0.12,0.15
Rigel,12100,21.0,78.9
"""
with open("stars.csv", "w", encoding="utf-8") as f:
    f.write(catalog)

# --- pandas で読み込む ---
df = pd.read_csv("stars.csv")
print("=== 全体 ===")
print(df)
print("\n=== 統計量 ===")
print(df["temp_K"].describe())

# --- 高温（6000 K 超）の星だけ絞り込む ---
hot = df[df["temp_K"] > 6000]
print("\n=== 高温の星 ===")
print(hot[["name", "temp_K"]])
print(f"\n高温の星の平均質量: {hot['mass'].mean():.2f} 太陽質量")
```

**実行結果の確認ポイント**: `stars.csv` が作られ、5 天体の表が表示されること。高温の星として Sirius・Rigel が選ばれ、平均質量が表示されれば正解。`df["temp_K"] > 6000` で行を絞り込めている点に注目する。

---

### 例 2 ― 列を計算して追加し、可視化する

カタログに **新しい列** を計算で追加し、Matplotlib（Week 6）で散布図にする。**例 1 を先に実行して `stars.csv` を作っておくこと**（無いと読み込みでエラーになる）。

```python
# week9_ex2.py
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

df = pd.read_csv("stars.csv")   # 例 1 で作った CSV を読む

# --- 主系列星の質量・光度関係 L ∝ M^3.5 で光度の目安を新しい列に ---
df["lum_approx"] = df["mass"] ** 3.5
print(df[["name", "mass", "lum_approx"]])

# --- 温度 vs 質量の散布図（NumPy 配列に変換して描く）---
x = df["temp_K"].values
y = df["mass"].values

plt.scatter(x, y)
for name, xi, yi in zip(df["name"], x, y):
    plt.annotate(name, (xi, yi))     # 各点に天体名を付ける
plt.xlabel("temperature [K]")
plt.ylabel("mass [solar]")
plt.title("Stars: temperature vs mass")
plt.grid(True)
plt.savefig("stars_scatter.png")
plt.show()
```

**実行結果の確認ポイント**: `lum_approx` 列が追加され、`stars_scatter.png` ができていれば成功。質量の大きい Betelgeuse・Rigel が上に来る散布図になっていること、各点に天体名が付いていることを確認する。

---

### 練習問題 6

以下の練習問題を `programing1/week9/` に `week9_practice6.py` として保存し、**提出すること**。`# %%` で区切ること。データファイルもこのフォルダの中に作る・読むようにすること。**この練習問題は例 1 で作る `stars.csv` を使う。先に例 1 を実行して `stars.csv` を用意してから取り組むこと**（無いと `FileNotFoundError` になる）。

**読み込みと絞り込み**: 例 1 の恒星カタログ（`stars.csv`）を `pd.read_csv` で読み込め。`df.describe()` で `temp_K` 列の統計量を表示したうえで、**質量が 1.0 太陽質量より大きい星** だけを絞り込み、その `name` と `mass` の 2 列を表示せよ。さらにその絞り込んだ星の `temp_K` の平均値を `print` で表示せよ。

---

### 応用問題 6（提出不要）

余裕がある人向けの発展問題。**提出は不要**。`sort_values` で表を並べ替える操作に挑戦してみよう。例 1 の `stars.csv` を使う。

**新しい列と並べ替え**: カタログに、半径から表面積に比例する量として **新しい列 `area`（= `radius` の 2 乗）** を追加せよ。その後、`df.sort_values("area", ascending=False)` で `area` の大きい順に並べ替え、`name` と `area` の 2 列を表示せよ（最も大きいのがどの天体か確認すること）。

プログラム例（解答例）:

```python
# 応用問題6 解答例
import pandas as pd

df = pd.read_csv("stars.csv")          # 例 1 で作った CSV を読む

df["area"] = df["radius"] ** 2          # 表面積に比例する量（半径の 2 乗）を新しい列に
ranked = df.sort_values("area", ascending=False)   # area の大きい順に並べ替え

print(ranked[["name", "area"]])
print(f"\n最も大きいのは {ranked.iloc[0]['name']}（area = {ranked.iloc[0]['area']:.1f}）")
```

**実行結果の確認ポイント**: `area` の降順に並んだ表が表示され、最も大きいのが Betelgeuse（半径が桁違いに大きい）になっていれば正解。`sort_values` の `ascending=False` で降順、`iloc[0]` で先頭行（＝最大）を取り出している点に注目する。
