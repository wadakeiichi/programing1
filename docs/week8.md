# Week 8　ファイル入出力とデータ解析

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

と入力して Enter キーを押し、`docs` フォルダを最新版に更新する。

更新が終わったら、自分の環境下に **`docs/week8.md` が存在すること** を必ず確認すること。VS Code 左側のエクスプローラーで `docs` フォルダを開き、`week8.md` が並んでいれば OK。または、ターミナルで次のコマンドを実行してファイルが表示されることを確認してもよい：

```bash
ls docs/week8.md
```

`docs/week8.md` が見つからない場合は、`make` が正しく実行できていない可能性があるので、プロンプトが `vscode ➜ /workspaces/programing1_student (main) $` になっているかを再確認し、もう一度 `make` を実行すること。

#### 自分の作業ファイル `week8.py` を作る

`docs` の更新が確認できたら、**授業用フォルダ（自分の作業フォルダ）の下** に `week8.py` という新しいファイルを作成する。VS Code のエクスプローラーで授業用フォルダを右クリック → 「新しいファイル」→ `week8.py` と入力すればよい。

今週も、解説中の **グレイ背景の Python コード** や 例１，２，… の例題部分を、この `week8.py` に **`# %%` 記法** を使って書き写しながら動作を試していく。`# %%` の行が **セルの区切り** になり、各セルの上に表示される `Run Cell` をクリックする（または `Shift + Enter`）と、そのセルだけが実行される。

```python
# %%
# セル1：辞書を試す
planet = {"name": "地球", "radius_km": 6371}
print(planet["name"], planet["radius_km"])

# %%
# セル2：配列をファイルに保存して読み戻す
import numpy as np
x = np.linspace(0, 1, 5)
np.savetxt("test.csv", x)
print(np.loadtxt("test.csv"))
```

> **指示**: 以降に出てくるグレイ背景のコードは、**そのまま読むだけでなく、必ず `week8.py` に `# %%` で区切りながら入力して動作を確認すること**。例題部分（例１，例２，…）も同様に、自分で入力して試すこと。コピペではなく **自分の手で打ち込む** ことで身につく。

---

### 今週のテーマ ― データを「ファイルとして残す／読み込む」

これまではプログラムの中で値を作り、`print` で画面に表示するだけだった。しかし実際のデータ解析では、

- 観測装置やシミュレーションが出力した **データファイルを読み込む**
- 計算結果を **ファイルに書き出して保存する**（次回また使う、他人に渡す）
- たくさんのファイルを **まとめて自動処理する（バッチ処理）**

といった「ファイルとのやりとり」が中心になる。今週は、そのための道具を 4 つ学ぶ。

| 道具 | 何をするか | 使う場面 |
|------|-----------|---------|
| 辞書 `dict` | 「名前」と「値」を対応づけて持つ | パラメータや観測値をまとめて管理 |
| `np.savetxt` / `np.loadtxt` | NumPy 配列をテキスト（CSV）で読み書き | 数値の表をファイルに残す・読む |
| `np.save` / `np.load` | NumPy 配列をバイナリで読み書き | 大きな配列を速く・正確に保存 |
| `glob` | 条件に合うファイル名を一覧で取得 | 大量のファイルをまとめて処理 |

さらに、表形式データを扱うライブラリ **pandas** の入り口も少しだけ触れる。

---

### 文法解説

#### 辞書（dict）― 名前で値を引く入れ物

リスト（Week 4）は値を **番号（インデックス）** で取り出した。これに対し **辞書（dictionary, `dict`）** は、**キー（key, 名前）** で値を取り出す入れ物である。`{キー: 値, ...}` の形で書く。

```python
# 1 つの天体の情報をまとめる
earth = {
    "name": "地球",
    "mass": 5.972e24,     # kg
    "radius": 6.371e6,    # m
}

print(earth["name"])    # キーで値を取り出す → 地球
print(earth["mass"])    # → 5.972e+24
```

値の追加・変更も「キーを指定して代入」するだけ。

```python
earth["moons"] = 1          # 新しいキーを追加
earth["radius"] = 6.371e6   # 既存のキーを上書き
```

キーが存在するか調べるには `in`、すべてのキー・値を順に取り出すには `.items()` を使う。

```python
print("mass" in earth)      # → True

for key, value in earth.items():
    print(f"{key} = {value}")
```

> **ポイント**: リストは「順番に並んだ値の列」、辞書は「名前で引ける値の対応表」。物理では「パラメータ名 → 値」「天体名 → データ」のように、**意味のある名前で値を管理したいとき** に辞書が便利。存在しないキーを `earth["age"]` のように指定すると `KeyError` になるので注意。

辞書を **リストに並べる** と、複数の天体をまとめて扱える（よく使うパターン）。

```python
bodies = [
    {"name": "地球", "radius": 6.371e6},
    {"name": "月",   "radius": 1.737e6},
    {"name": "火星", "radius": 3.390e6},
]

for b in bodies:
    print(f"{b['name']}: 半径 {b['radius']/1000:.0f} km")
```

---

#### テキストファイルとして保存・読み込み ― np.savetxt / np.loadtxt

NumPy 配列を **テキストファイル（CSV など）** に書き出すには `np.savetxt`、読み込むには `np.loadtxt` を使う。CSV（comma-separated values）は「カンマ区切りの数値の表」で、Excel でも開ける汎用的な形式。

```python
import numpy as np

# 保存するデータを作る（時刻 t と、その時の高さ y）
t = np.linspace(0, 2, 5)        # 0〜2 秒を 5 点
y = 20 * t - 0.5 * 9.81 * t**2  # 鉛直投げ上げの高さ

# 2 列の表として保存する。column_stack で列方向に並べる
data = np.column_stack([t, y])
np.savetxt("throw.csv", data, delimiter=",",
           header="t,y", comments="")
```

- **`delimiter=","`**: 値の区切りをカンマにする（CSV にする）。省略するとスペース区切り。
- **`header="t,y"`**: ファイルの先頭に付ける見出し行。
- **`comments=""`**: header の行頭に付く `#` を消す（Excel で開きやすくするため）。

保存したファイルを読み込むには `np.loadtxt`。

```python
data = np.loadtxt("throw.csv", delimiter=",", skiprows=1)
t = data[:, 0]   # 1 列目（すべての行の 0 番目）
y = data[:, 1]   # 2 列目
print(t)
print(y)
```

- **`skiprows=1`**: 先頭の見出し行（`t,y`）を読み飛ばす。
- **`data[:, 0]`**: 「すべての行の 0 列目」を取り出すスライス記法（Week 5 で学んだ `:` の応用）。

> **ポイント**: `np.savetxt` / `np.loadtxt` は **数値だけの表** を読み書きするのに向いている。文字列が混ざった列があるとうまく読めないことがある（その場合は後述の pandas を使う）。

---

#### バイナリとして保存・読み込み ― np.save / np.load

テキスト（CSV）は人間が読めて便利だが、大きな配列だと **ファイルが重く・遅く・誤差が出る** ことがある（小数を文字に変換するため）。配列を **そのままの形で速く正確に** 保存したいときは、バイナリ形式の `np.save` / `np.load` を使う。拡張子は `.npy`。

```python
import numpy as np

a = np.linspace(0, 10, 1000)

np.save("a.npy", a)      # バイナリで保存（拡張子 .npy が自動で付く）
b = np.load("a.npy")     # 読み込み

print(np.allclose(a, b))  # → True（完全に一致）
```

> **使い分け**: 他人に渡す・Excel で見る・中身を目で確認したい → **CSV（savetxt/loadtxt）**。自分の計算の途中結果を一時保存する・大きな配列を速く扱いたい → **バイナリ（save/load）**。`np.allclose` は「2 つの配列がほぼ等しいか」を判定する便利な関数。

---

#### pandas の基本 ― 表データを扱うライブラリ

**pandas** は「行と列を持つ表（テーブル）」を扱うためのライブラリで、観測データや実験データの解析で広く使われる。表全体を **DataFrame（データフレーム）** というオブジェクトで持つ。慣習として `import pandas as pd` と書く。

```python
import pandas as pd

# CSV ファイルを読み込む（見出し行は自動で認識される）
df = pd.read_csv("throw.csv")
print(df)            # 表全体を表示
print(df.columns)    # 列名の一覧
```

列は **列名** で取り出せる（辞書に似た書き方）。

```python
print(df["t"])       # t 列だけ取り出す
print(df["y"].max()) # y 列の最大値
print(df["y"].mean())# y 列の平均
```

**条件で行を絞り込む** こともできる（データ解析でよく使う）。

```python
# y が 10 より大きい行だけ取り出す
high = df[df["y"] > 10]
print(high)
```

pandas の列や DataFrame は、`.values` または `np.array(...)` で NumPy 配列に変換でき、これまで学んだ NumPy / Matplotlib の道具とそのままつなげられる。

```python
import numpy as np
t = df["t"].values    # NumPy 配列に変換
y = np.array(df["y"])
```

> **ポイント**: `np.loadtxt` が「数値だけの表」向きなのに対し、pandas は **文字列と数値が混ざった表**・**欠損値のある表**・**見出し付きの表** を柔軟に扱える。本格的なデータ解析では pandas が主役になるが、今週はまず「CSV を読んで、列を取り出して、条件で絞る」という基本だけ押さえる。

---

#### glob ― 条件に合うファイルをまとめて処理（バッチ処理）

実験やシミュレーションでは、`run01.csv`, `run02.csv`, … のように **同じ形式のファイルが何十個もできる** ことがある。これを 1 つずつ手で開くのは大変なので、**`glob`** を使ってファイル名を一括取得し、ループでまとめて処理する。これを **バッチ処理** という。

```python
import glob

# data フォルダの中の、.csv で終わるファイルをすべて取得
files = glob.glob("data/*.csv")
files.sort()          # 名前順に並べておく（順番を安定させる）
print(files)          # → ['data/run01.csv', 'data/run02.csv', ...]
```

- **`*`** は「任意の文字列」を表すワイルドカード。`data/*.csv` は「data フォルダ内の、拡張子 csv の全ファイル」の意味。
- 返ってくる順序は環境によってばらつくので、**`.sort()` で並べ替える** 習慣をつけるとよい。

取得したファイル名のリストを `for` で回せば、全ファイルをまとめて処理できる。

```python
import numpy as np

for f in files:
    data = np.loadtxt(f, delimiter=",", skiprows=1)
    print(f"{f}: 行数 {len(data)}, y の最大 {data[:,1].max():.2f}")
```

> **ポイント**: 「ファイル名を `glob` で集める → `for` で 1 つずつ読み込む → 結果をまとめる」が、バッチ処理の基本形。手作業を自動化できるので、データが増えても同じコードで処理できる。

---

### 例 1 ― 計算結果を CSV に保存して読み戻し、グラフにする

鉛直投げ上げの「時刻 t と高さ y」を計算して CSV に保存し、別のセルで読み戻して Matplotlib（Week 6）でグラフにする。**「計算 → 保存 → 読み込み → 可視化」** という解析の一連の流れを体験する。

```python
# week8_ex1.py
import numpy as np
import matplotlib.pyplot as plt

# --- 計算してファイルに保存 ---
v0, g = 20.0, 9.81
t = np.linspace(0, 2 * v0 / g, 50)   # 落ちてくるまでの時間
y = v0 * t - 0.5 * g * t**2

data = np.column_stack([t, y])
np.savetxt("throw.csv", data, delimiter=",", header="t,y", comments="")
print("throw.csv に保存した")

# --- 読み戻してグラフにする ---
loaded = np.loadtxt("throw.csv", delimiter=",", skiprows=1)
t2, y2 = loaded[:, 0], loaded[:, 1]

plt.plot(t2, y2)
plt.xlabel("time [s]")
plt.ylabel("height [m]")
plt.title("Vertical throw")
plt.grid(True)
plt.savefig("throw.png")
plt.show()
```

**実行結果の確認ポイント**: `throw.csv` と `throw.png` が作業フォルダにできていれば成功。グラフが上に凸の放物線になっていること、保存前 `y` と読み戻した `y2` が同じ形になっていることを確認する。

---

### 例 2 ― glob で複数ファイルをまとめて解析する（バッチ処理）

まず実験データに見立てた CSV を 3 つ自動生成し、その後 `glob` で集めてまとめて読み込み、各ファイルの統計量を表にする。

```python
# week8_ex2.py
import numpy as np
import glob
import os

# --- 練習用のデータファイルを 3 つ作る（本来は観測装置が出力するもの）---
os.makedirs("runs", exist_ok=True)   # runs フォルダを作る（あってもエラーにしない）
rng = np.random.default_rng(0)       # 乱数（再現性のため種を固定）
for i in range(1, 4):
    t = np.linspace(0, 1, 20)
    signal = np.sin(2 * np.pi * i * t) + 0.1 * rng.standard_normal(20)
    np.savetxt(f"runs/run{i:02d}.csv", np.column_stack([t, signal]),
               delimiter=",", header="t,signal", comments="")

# --- glob で集めてまとめて解析する ---
files = glob.glob("runs/*.csv")
files.sort()

results = []   # 各ファイルの結果を辞書で貯めていく
for f in files:
    data = np.loadtxt(f, delimiter=",", skiprows=1)
    sig = data[:, 1]
    results.append({
        "file": f,
        "max": sig.max(),
        "min": sig.min(),
        "mean": sig.mean(),
    })

# --- 結果の表を表示 ---
print(f"{'file':14s} {'max':>7s} {'min':>7s} {'mean':>7s}")
for r in results:
    print(f"{r['file']:14s} {r['max']:7.3f} {r['min']:7.3f} {r['mean']:7.3f}")
```

**実行結果の確認ポイント**: `runs/` フォルダに `run01.csv`〜`run03.csv` ができ、3 ファイル分の max/min/mean が表として表示されれば成功。`glob` で集めたファイルを `for` で回し、結果を **辞書のリスト** に貯めている点に注目する。

---

### 練習問題 5

以下の練習問題を `programing1/week8/` に `week8_practice5.py` として保存せよ。各問題は `# %%` で区切ること。データファイルもこのフォルダの中に作る・読むようにすること。

1. **辞書**: 太陽系の天体を辞書のリストで定義せよ。各辞書は `name`（名前）、`mass`（質量 [kg]）、`radius`（半径 [m]）の 3 つのキーを持つこと（地球・月・火星の 3 つでよい）。`for` で全天体を回し、各天体の **平均密度** ρ = mass / (4/3 · π · radius³) [kg/m³] を計算して `「名前: 密度 ... kg/m³」` の形で表示せよ。

2. **CSV の保存と読み込み**: 角度 θ = 0〜90 度（10 点）に対する斜方投射の飛距離 R = v₀² sin(2θ) / g（v₀ = 20 m/s, g = 9.81）を計算し、θ と R の 2 列を `range.csv` に `np.savetxt` で保存せよ（header 付き）。続けて別セルで `np.loadtxt` で読み戻し、`np.loadtxt` した R の **最大値とそのときの角度** を求めて表示せよ（理論上は 45 度で最大になる。10 点では 45 度ちょうどが含まれないので最寄りの角度になることを確認し、なぜそうなるか考えよ）。

3. **バッチ処理**: 例 2 を参考に、`runs/` フォルダに練習用 CSV を 5 つ自動生成せよ（中身は各自で決めてよい）。その後 `glob` で 5 ファイルを集め、各ファイルの平均値を計算し、**ファイル名と平均値の対応** を辞書にまとめて表示せよ。さらに、平均値が最大だったファイル名を求めて表示すること。
