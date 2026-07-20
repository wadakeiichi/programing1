# Week 12　フィッティング・コマンドライン・バッチ処理

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
> ① と ② が揃っていない状態で `make` を打っても **絶対に動きません**。`初期設定ガイド2027.md` の Step 8 〜 Step 10 を見直してください。

---

授業を始める前に、**dev container 環境下** の VS Code ターミナル（プロンプトが `vscode ➜ /workspaces/programing1_student (main) $`）で `make` を実行し、`docs` を更新しておくこと。

```bash
make
ls docs/week12.md
```

更新を確認したら、作業フォルダに `week12.py` を作り、解説中のコードを **`# %%` 記法** で書き写しながら試すこと。

```python
# %%
# セル1：curve_fit の最小例（直線あてはめ）
import numpy as np
from scipy.optimize import curve_fit

def line(x, a, b):
    return a * x + b

x = np.array([0, 1, 2, 3, 4])
y = np.array([0.1, 2.1, 3.9, 6.2, 7.8])
popt, pcov = curve_fit(line, x, y)
print("傾き a, 切片 b =", popt)
```

---

### 今週のテーマ ― データにモデルを当てはめる

実験や観測で得たデータには **ノイズ** が乗っている。そのデータの背後にある **モデル関数**（直線・指数・ガウス関数など）の **パラメータ** を推定するのが **フィッティング（曲線あてはめ）** である。物理では「測定データから物理定数を求める」ときに必須の技術。

今週は SciPy の **`scipy.optimize.curve_fit`** でフィッティングを行い、さらに **`argparse`**（コマンドライン引数）と **bash のループ** を組み合わせて、パラメータを変えながらプログラムを **バッチ実行** する方法を学ぶ。

| やること | 使う道具 |
|---------|---------|
| モデルを当てはめる | `curve_fit(model, x, y, p0=...)` |
| パラメータの誤差を出す | `np.sqrt(np.diag(pcov))` |
| コマンドライン引数を受け取る | `argparse` |
| 引数を変えて連続実行 | bash の `for` ループ |

---

### 文法解説

#### curve_fit の基本

まず **モデル関数** を定義する。**第 1 引数が x、以降がパラメータ** という形にする。`curve_fit` はデータ `x, y` に最もよく合うパラメータを探す。

```python
# 【書き方の型】← そのまま実行しないこと（下の「動く最小の例」を打ち込むこと）
from scipy.optimize import curve_fit

def model(x, a, b):
    return a * np.exp(-b * x)      # 例：指数関数モデル

popt, pcov = curve_fit(model, x_data, y_data, p0=[1.0, 0.5])   # ← x_data, y_data は仮の名前
```

> **⚠ 上のコードは「書き方の型」であり、そのままでは動きません。** `x_data`・`y_data` は **仮の名前** なので、実行すると `NameError` になります。**打ち込んで動かすのは、下の「動く最小の例」から** にしてください。

- **`popt`**: 最適化されたパラメータ（optimized parameters）。`model(x, *popt)` でフィット曲線を描ける。
- **`pcov`**: 共分散行列。**対角成分の平方根がパラメータの標準誤差** になる。
- **`p0`**: パラメータの初期推定値。

> **`popt, pcov = ...` の書き方について**: `curve_fit` は **2 つの結果をまとめて返す** ので、左辺にカンマで 2 つ並べて受け取る。これは Week 7 で学んだ **複数の戻り値の受け取り方** と同じ書き方（`distance, height = projectile_range(20.0, 45)`）。Week 10 の `X, Y = np.meshgrid(x, y)` も同じ形である。**返ってくる値の個数だけ、左辺に名前をカンマで並べる** と覚えればよい。

次が **実際に動く最小の例**。データを用意し、フィットして、パラメータと誤差まで表示する。

```python
# 動く最小の例
import numpy as np
from scipy.optimize import curve_fit

# データ（本来は測定・観測で得たもの）
x_data = np.linspace(0, 5, 20)
y_data = 3.0 * np.exp(-0.8 * x_data)

def model(x, a, b):
    return a * np.exp(-b * x)

popt, pcov = curve_fit(model, x_data, y_data, p0=[1.0, 0.5])

a_fit, b_fit = popt
perr = np.sqrt(np.diag(pcov))       # 各パラメータの標準誤差
print(f"a = {a_fit:.3f} ± {perr[0]:.3f}")   # 真値 3.0 に近いはず
print(f"b = {b_fit:.3f} ± {perr[1]:.3f}")   # 真値 0.8 に近いはず
```

#### 初期値 p0 の重要性

`curve_fit` は初期値 `p0` から出発して最適解を探す。**初期値が悪いと、正しい解にたどり着けない**（局所解に落ちる・収束しない）ことがある。とくに指数関数やガウス関数など非線形なモデルでは、**おおよその値を `p0` に与える** ことが重要。

```python
# p0 を与えないと [1, 1, ...] から探索する。非線形モデルでは失敗しやすい
# （上の「動く最小の例」の x_data, y_data, model をそのまま使う）
curve_fit(model, x_data, y_data, p0=[2.0, 0.3])   # 物理的に妥当な初期値を渡す
```

> **ポイント**: フィットがうまくいかないときは、まず **`p0` を見直す**。データのグラフを見て「振幅はこのくらい」「減衰の速さはこのくらい」と当たりをつけて初期値にする。

#### argparse ― コマンドライン引数を受け取る

これまでは値をコード中に直接書いていた。**`argparse`** を使うと、**ターミナルから値を渡して** プログラムを実行できる。パラメータを変えて何度も実行したいときに便利。

```python
# fit_run.py
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--noise", type=float, default=0.1,
                    help="ノイズの大きさ")
parser.add_argument("--n", type=int, default=50,
                    help="データ点数")
args = parser.parse_args()

print(args.noise, args.n)   # 受け取った値を使う
```

ターミナルからは次のように実行する（**VS Code のターミナル**で）。

```bash
python fit_run.py --noise 0.2 --n 100
```

- `--noise 0.2` のように **`--名前 値`** で渡す。指定しなければ `default` の値が使われる。
- `type=float` / `type=int` で型を指定する。

> **注意**: `argparse` を使うスクリプトは **ターミナルから `python ファイル名.py` で実行** する。`# %%` のセル実行では引数を渡せないので、この部分だけはターミナルを使うこと。

#### bash の for ループ ― パラメータスキャン

同じプログラムを **引数を変えて何度も実行** したいときは、bash の `for` ループを使う（Week 2 の復習）。これを **パラメータスキャン** と呼ぶ。

```bash
for noise in 0.05 0.1 0.2 0.4
do
    python fit_run.py --noise $noise --n 100
done
```

`$noise` にリストの値が順に入り、4 通りのノイズで自動実行される。手作業で値を書き換えて実行を繰り返す必要がなくなる。

---

### 例 1 ― 指数減衰データをフィットする

ノイズを乗せた指数減衰データを作り、`curve_fit` でモデル y = A·exp(−k·x) のパラメータ A, k を推定する。**真の値と推定値・誤差を比較** する。

#### なぜ「わざと乱数でノイズを作る」のか

本来フィッティングは、**測定して得たデータ**（真の値が分からないもの）に対して行う。しかし練習では「フィットの結果が正しいか」を確かめたい。そこで **真の値を自分で決めて（A = 5.0, k = 0.7）、そこに人工的なノイズを足したデータ** を作る。こうすると、フィットで求めた値が **真の値に戻ってくるか** で、手順が正しいか検証できる。これは数値計算の練習でよく使う考え方（Week 11 で数値解を解析解と比べたのと同じ発想）。

そのノイズを作るのが **乱数** である。書き方は Week 6 のヒストグラムの例で一度使ったものと同じ。

```python
import numpy as np

rng = np.random.default_rng(0)          # 乱数の生成器を用意する（0 は「種」）
noise = rng.normal(0, 0.15, size=5)     # 平均 0・標準偏差 0.15 の正規分布から 5 個
print(noise)
```

- **`np.random.default_rng(0)`**: 乱数を作る装置（generator）を用意する。**`rng` という名前で以降使う**。
- **`0` は「種（シード, seed）」**: 乱数の出発点を決める番号。**同じ種なら毎回まったく同じ乱数列** が出る。こうしておくと、**誰が何回実行しても同じ結果** になり、教材の数値と突き合わせて確認できる（再現性）。種を変えれば別のノイズになる。
- **`rng.normal(平均, 標準偏差, size=個数)`**: **正規分布（ガウス分布）** に従う乱数を指定個数作る。測定誤差は正規分布に従うことが多いので、測定データの模擬に使う。`size=x.size` とすれば「x と同じ個数」になる。

> **ポイント**: 実際の研究では、乱数でデータを作るのではなく **観測・実験データを読み込む**（Week 8・9 の `np.loadtxt` / `pd.read_csv`）。ここで乱数を使うのは、**答え合わせができる練習用データ** を手軽に用意するため。

```python
# week12_ex1.py
import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit

# --- 真のパラメータでノイズ入りデータを生成 ---
rng = np.random.default_rng(0)
A_true, k_true = 5.0, 0.7
x = np.linspace(0, 5, 40)
y = A_true * np.exp(-k_true * x) + rng.normal(0, 0.15, size=x.size)

# --- モデルを定義してフィット ---
def model(x, A, k):
    return A * np.exp(-k * x)

popt, pcov = curve_fit(model, x, y, p0=[1.0, 1.0])
perr = np.sqrt(np.diag(pcov))
print(f"A = {popt[0]:.3f} ± {perr[0]:.3f}  (真値 {A_true})")
print(f"k = {popt[1]:.3f} ± {perr[1]:.3f}  (真値 {k_true})")

# --- データとフィット曲線を描く ---
plt.plot(x, y, "o", markersize=4, label="data")
plt.plot(x, model(x, *popt), "-", label="fit")
plt.xlabel("x")
plt.ylabel("y")
plt.legend()
plt.title("Exponential fit")
plt.savefig("fit.png")
plt.show()
```

**実行結果の確認ポイント**: 推定された A, k が真値（5.0, 0.7）に近いこと、`fit.png` でフィット曲線がデータの中心を通っていれば成功。`± 誤差` が `np.sqrt(np.diag(pcov))` から得られている点に注目する。

---

### 例 2 ― argparse と bash でパラメータスキャン

ノイズの大きさをコマンドラインから受け取り、フィット結果を出力するスクリプトを作る。bash のループでノイズを変えながら実行し、**ノイズが大きいほど推定誤差が大きくなる** ことを確認する。

> **⚠ ここだけ進め方が変わります**: これまでは `week12.py` に `# %%` でセルを書き、`Run Cell` で実行してきた。**この例 2 だけは「独立した .py ファイル」を作り、ターミナルから実行する**。理由は、`argparse` が **コマンドラインから渡す引数** を受け取る仕組みだから。セル実行では引数を渡せないので、この例に限りターミナルを使う。下の **手順 1 〜 4 の順に** 進めること。

#### 手順 1: ファイルを作る

VS Code のエクスプローラーで、作業フォルダに **`week12_ex2.py`** という新しいファイルを作り、次を書いて **保存する**（`Ctrl + S` / `Cmd + S`）。`# %%` は書かない。ふつうの Python ファイルとして作る。

```python
# week12_ex2.py
import argparse
import numpy as np
from scipy.optimize import curve_fit

parser = argparse.ArgumentParser()
parser.add_argument("--noise", type=float, default=0.1)
args = parser.parse_args()

rng = np.random.default_rng(0)
A_true, k_true = 5.0, 0.7
x = np.linspace(0, 5, 40)
y = A_true * np.exp(-k_true * x) + rng.normal(0, args.noise, size=x.size)

def model(x, A, k):
    return A * np.exp(-k * x)

popt, pcov = curve_fit(model, x, y, p0=[1.0, 1.0])
perr = np.sqrt(np.diag(pcov))
print(f"noise={args.noise:4.2f} -> A={popt[0]:.3f}±{perr[0]:.3f}, k={popt[1]:.3f}±{perr[1]:.3f}")
```

#### 手順 2: まず 1 回だけ手で実行してみる

**VS Code のターミナル**（プロンプトが `vscode ➜ ... $`）を開く。まず `week12_ex2.py` を保存したフォルダに `cd` で移動し、**引数を 1 つ指定して 1 回だけ** 実行する。

```bash
python week12_ex2.py --noise 0.1
```

次のように 1 行だけ出力されれば成功。

```
noise=0.10 -> A=5.025±0.044, k=0.711±0.009
```

ここで **`--noise 0.1` の数字を変えて、何度か手で実行してみる**（例：`--noise 0.4`）。ノイズを変えると `±` の後ろの誤差が変わることが分かる。

```bash
python week12_ex2.py --noise 0.4
```

#### 手順 3: 「手で 4 回打つ」のを自動化する

手順 2 を 0.05・0.1・0.2・0.4 の 4 通りで試したいとする。毎回コマンドを打ち直すのは面倒で、打ち間違いも起きる。そこで **bash の `for` ループ** で自動化する。

まずは **1 行で書く形** を使う（コピーして貼り付けやすい）。ターミナルに次を貼り付けて `Enter`：

```bash
for noise in 0.05 0.1 0.2 0.4; do python week12_ex2.py --noise $noise; done
```

この 1 行が何をしているかを分解すると、次のようになる。

| 部分 | 意味 |
|------|------|
| `for noise in 0.05 0.1 0.2 0.4` | 変数 `noise` に、4 つの値を **順に 1 つずつ** 入れる |
| `do ... done` | `do` と `done` の間が **くり返す中身** |
| `python week12_ex2.py --noise $noise` | 実行するコマンド。**`$noise` が今回の値に置き換わる** |
| `;`（セミコロン） | 1 行に詰めて書くときの **区切り**（改行の代わり） |

つまり「`--noise 0.05` で 1 回、`--noise 0.1` で 1 回、…」を **4 回自動で実行**している。手順 2 で手で打ったことを、機械にやらせているだけである。

> **`$` の意味**: bash では、変数の**中身を取り出す**ときに名前の前に `$` を付ける。`noise` は「変数の名前」、`$noise` は「その中に入っている値」。だから `for noise in ...` の側には `$` を付けず、使う側の `--noise $noise` には付ける。

#### 手順 4: 実行結果を確かめる

次のように **4 行** 出力される。

```
noise=0.05 -> A=5.012±0.022, k=0.705±0.005
noise=0.10 -> A=5.025±0.044, k=0.711±0.009
noise=0.20 -> A=5.051±0.089, k=0.723±0.019
noise=0.40 -> A=5.108±0.180, k=0.747±0.039
```

**実行結果の確認ポイント**: ノイズ 0.05 → 0.4 と大きくするにつれ、**`±` の後ろの誤差が 0.022 → 0.180 と大きくなっていく** ことが読み取れれば成功。データが汚いほどパラメータの推定が不確かになる、という当たり前の事実が数値で確認できる。同じスクリプトを **引数だけ変えて 4 回自動実行** できている点に注目する。

> **複数行で書く書き方**: 教科書やネットでは、次のように改行して書かれていることが多い（意味は 1 行版とまったく同じ）。
>
> ```bash
> for noise in 0.05 0.1 0.2 0.4
> do
>     python week12_ex2.py --noise $noise
> done
> ```
>
> ターミナルでこの形を打つ場合、1 行目で `Enter` を押すと **プロンプトが `>` に変わる**。これは「コマンドがまだ途中です」という合図で、エラーではない。`done` を打って `Enter` を押すと、そこで初めて実行される。**途中でやめたいときは `Ctrl + C`**。慣れないうちは 1 行版で書くのが安全。

---

### 練習問題 9

以下の練習問題を `programing1/week12/` に保存し、**提出すること**。図は `plt.savefig` で保存すること。

1. **直線フィット**: `week12_practice9.py` を作れ。真の直線 y = 2.0·x + 1.0 にノイズ（標準偏差 0.5）を乗せたデータを x = 0〜10（30 点）で作り、モデル `def line(x, a, b): return a*x + b` を `curve_fit` で当てはめよ。推定した傾き a・切片 b とそれぞれの標準誤差（`np.sqrt(np.diag(pcov))`）を `print` で表示し、データ点とフィット直線を重ねたグラフを保存せよ。

2. **argparse でデータ点数を変える**: `week12_practice9b.py` を作れ。`argparse` で `--n`（データ点数, 既定 30）を受け取り、問 1 と同じ直線フィットを行って、傾き a の標準誤差を出力するスクリプトにせよ。続けて、bash のループで `--n` を 10, 30, 100, 300 と変えて実行し、**データ点数が多いほど誤差が小さくなる** ことを確認せよ（bash で実行したコマンドと結果をコメントで貼り付けておくこと）。
