# Week 10　NumPy 2D 配列と可視化

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

> **重要**: ここで使うのは **VS Code のターミナル** であり、**Mac の「ターミナル」アプリや Windows の PowerShell／コマンドプロンプトではない**。VS Code のターミナルで dev container に正しく入っていれば、プロンプトは次のようになっているはず：
>
> ```
> vscode ➜ /workspaces/programing1_student (main) $
> ```
>
> もしプロンプトが上のようになっていない場合は、ターミナルを開く場所・環境を間違えているので開き直すこと。

ターミナルで

```bash
make
```

を実行して `docs` フォルダを最新版に更新し、`docs/week10.md` が存在することを確認する。

```bash
ls docs/week10.md
```

#### 自分の作業ファイル `week10.py` を作る

`docs` の更新が確認できたら、**授業用フォルダ（自分の作業フォルダ）の下** に `week10.py` という新しいファイルを作成する。今週も、解説中の **グレイ背景の Python コード** や例題部分を、この `week10.py` に **`# %%` 記法** で書き写しながら動作を試していく。

```python
# %%
# セル1：2 次元配列を作って形を見る
import numpy as np
a = np.array([[1, 2, 3],
              [4, 5, 6]])
print(a)
print(a.shape)   # (行数, 列数)

# %%
# セル2：格子点を作って 2 変数関数を評価する
x = np.linspace(-2, 2, 5)
y = np.linspace(-2, 2, 5)
X, Y = np.meshgrid(x, y)
Z = X**2 + Y**2
print(Z)
```

> **指示**: 以降のグレイ背景のコードは、**そのまま読むだけでなく、必ず `week10.py` に `# %%` で区切りながら入力して動作を確認すること**。例題部分も同様に、自分で入力して試すこと。

---

### 今週のテーマ ― 「面」のデータを扱う

Week 5 では 1 次元の NumPy 配列（数列・ベクトル）を、Week 6 では折れ線グラフを学んだ。今週は **2 次元配列（2D array）**、つまり **行と列を持つ格子状のデータ** を扱う。

物理・天文では 2 次元データが頻出する：温度や電位の **空間分布**、天体の **画像（ピクセルの明るさ）**、2 変数関数 z = f(x, y) の値など。これらを **作る・一部を取り出す（スライス）・図にする** 方法を身につける。

| やること | 使う道具 |
|---------|---------|
| 2D 配列を作る | `np.array([[...]])` / `np.zeros((r,c))` / `reshape` |
| 一部を取り出す | スライス `a[i, j]` / `a[i, :]` / `a[:, j]` |
| 格子点を作る | `np.meshgrid(x, y)` |
| 等高線で描く | `plt.contourf` / `plt.contour` |
| 画像として描く | `plt.imshow` |
| 色の目盛りを付ける | `plt.colorbar` |

---

### 文法解説

#### 2 次元配列の作成と形（shape）

2 次元配列は「配列の配列」（リストのリスト）から作る。**外側が行、内側が列**。

```python
import numpy as np

a = np.array([[1, 2, 3],
              [4, 5, 6]])
print(a.shape)   # (2, 3) → 2 行 3 列
print(a.ndim)    # 2 → 次元数
```

決まった大きさの配列は関数で作れる。

```python
np.zeros((3, 4))       # 3 行 4 列の 0 埋め配列
np.ones((2, 2))        # 1 埋め
np.arange(12).reshape(3, 4)   # 0〜11 を 3 行 4 列に並べ替える
```

> **ポイント**: `reshape(r, c)` は要素数が合っていないとエラーになる（`np.arange(12)` は 12 個なので 3×4 や 2×6 に変形できる）。

#### スライシング ― 行・列・一部を取り出す

2D 配列は **`[行, 列]`** の形で指定する（Week 5 の 1D スライスにカンマで次元が増える）。

```python
a = np.arange(12).reshape(3, 4)
print(a[0, 2])     # 0 行 2 列目の 1 要素
print(a[1, :])     # 1 行目の全列（1 行まるごと）
print(a[:, 2])     # 2 列目の全行（1 列まるごと）
print(a[0:2, 1:3]) # 0〜1 行かつ 1〜2 列の部分ブロック
```

- `:` は「その次元は全部」の意味。
- `a[1, :]` は 2 行目、`a[:, 2]` は 3 列目。**カンマの前が行、後が列** と覚える。

集計関数（Week 5）は **軸（axis）** を指定できる。

```python
print(a.sum())          # 全要素の合計
print(a.sum(axis=0))    # 列ごとの合計（縦方向にたす）
print(a.sum(axis=1))    # 行ごとの合計（横方向にたす）
```

#### meshgrid ― 格子点を作って 2 変数関数を評価する

z = f(x, y) のような **2 変数関数** を面として描くには、xy 平面上の **格子点（grid）** すべてで z を計算する必要がある。`np.meshgrid` は、x 方向と y 方向の 1D 配列から、**格子点の X 座標・Y 座標をそれぞれ 2D 配列で** 作ってくれる。

```python
x = np.linspace(-2, 2, 5)     # x 方向 5 点
y = np.linspace(-2, 2, 5)     # y 方向 5 点
X, Y = np.meshgrid(x, y)      # X, Y はともに (5, 5) の 2D 配列

Z = X**2 + Y**2               # 各格子点で z = x^2 + y^2 を一気に計算
print(Z.shape)                # (5, 5)
```

`X` と `Y` を使えば、ブロードキャスト（Week 5）で **全格子点の z を 1 行で** 計算できる（for ループ不要）。この `Z` が「面」のデータになる。

#### 等高線で描く ― contourf / contour + colorbar

`Z` を **等高線** で可視化するのが `contourf`（塗りつぶし）と `contour`（線）。値の大小が色で分かる。`colorbar` で色と値の対応を示す。

```python
import matplotlib.pyplot as plt

x = np.linspace(-2, 2, 100)
y = np.linspace(-2, 2, 100)
X, Y = np.meshgrid(x, y)
Z = X**2 + Y**2

plt.contourf(X, Y, Z, levels=20, cmap="viridis")  # 塗りつぶし等高線
plt.colorbar(label="z = x^2 + y^2")               # 色の目盛り
plt.contour(X, Y, Z, levels=10, colors="white", linewidths=0.5)  # 線を重ねる
plt.xlabel("x")
plt.ylabel("y")
plt.savefig("contour.png")
```

- **`levels`**: 等高線の段階数（多いほど滑らか）。
- **`cmap`**: カラーマップ（`viridis`, `plasma`, `inferno`, `coolwarm` など）。
- `contourf` の上に `contour` を重ねると、塗り＋線の見やすい図になる。

#### 画像として描く ― imshow

2D 配列を **そのままピクセル画像** として描くのが `imshow`。天体画像やピクセルマップの表示に使う。

```python
plt.imshow(Z, extent=[-2, 2, -2, 2], origin="lower", cmap="inferno")
plt.colorbar(label="value")
plt.xlabel("x")
plt.ylabel("y")
plt.savefig("image.png")
```

- **`extent=[xmin, xmax, ymin, ymax]`**: 画像の座標範囲を指定（付けないとピクセル番号になる）。
- **`origin="lower"`**: 配列の 0 行目を **下** に置く（付けないと上下が反転する。数学の座標に合わせるには `"lower"`）。

> **contourf と imshow の違い**: `contourf` は「等高線として段階的に」、`imshow` は「各ピクセルの値をそのまま連続的に」描く。天体画像のような **画素データは imshow**、2 変数関数の分布は **contourf** が向くことが多い。どちらも `colorbar` で値の目盛りを付ける。

---

### 例 1 ― 2 次元ガウス分布を等高線で描く

星像の光の広がり（点像分布）などに現れる **2 次元ガウス分布** z = exp(−(x² + y²)) を、meshgrid で評価して contourf で描く。

```python
# week10_ex1.py
import numpy as np
import matplotlib.pyplot as plt

# --- 格子点を作る ---
x = np.linspace(-3, 3, 200)
y = np.linspace(-3, 3, 200)
X, Y = np.meshgrid(x, y)

# --- 全格子点で 2 次元ガウスを計算 ---
Z = np.exp(-(X**2 + Y**2))

# --- 等高線で可視化 ---
plt.contourf(X, Y, Z, levels=30, cmap="viridis")
plt.colorbar(label="intensity")
plt.contour(X, Y, Z, levels=6, colors="white", linewidths=0.5)
plt.xlabel("x")
plt.ylabel("y")
plt.title("2D Gaussian")
plt.gca().set_aspect("equal")   # x と y の比を 1:1 にする（円が円に見える）
plt.savefig("gaussian.png")
plt.show()

print("最大値:", Z.max(), "→ 中心 (0,0) で 1 になるはず")
```

**実行結果の確認ポイント**: `gaussian.png` ができ、中心が明るい同心円状の分布になっていれば成功。`Z.max()` が中心の 1.0 に近いこと、`set_aspect("equal")` で円形に見えることを確認する。

---

### 例 2 ― 2 つの点電荷のポテンシャルを imshow で描く

xy 平面上の 2 点に置いた電荷が作る電位 V = k·(q₁/r₁ + q₂/r₂) を格子点で計算し、`imshow` でピクセルマップとして描く。

```python
# week10_ex2.py
import numpy as np
import matplotlib.pyplot as plt

x = np.linspace(-3, 3, 300)
y = np.linspace(-3, 3, 300)
X, Y = np.meshgrid(x, y)

def potential(X, Y, q, x0, y0):
    """点電荷 (x0, y0, 電荷 q) が作る電位。中心の発散を避けるため微小量を足す"""
    r = np.sqrt((X - x0)**2 + (Y - y0)**2) + 1e-3
    return q / r

# 正電荷 (+1) と負電荷 (-1) を左右に置く
V = potential(X, Y, +1, -1, 0) + potential(X, Y, -1, +1, 0)

# 値が発散しやすいので表示範囲を制限する
plt.imshow(V, extent=[-3, 3, -3, 3], origin="lower",
           cmap="coolwarm", vmin=-2, vmax=2)
plt.colorbar(label="potential")
plt.xlabel("x")
plt.ylabel("y")
plt.title("Potential of two charges")
plt.savefig("potential.png")
plt.show()
```

**実行結果の確認ポイント**: `potential.png` ができ、左（+電荷）が赤く、右（−電荷）が青くなる分布になっていれば成功。`imshow` の `origin="lower"` と `extent` で座標が正しく設定され、`vmin`/`vmax` で色の範囲を制限している点に注目する。

> **やってみよう ― カラーマップ（`cmap`）を変える**: `imshow(...)` の `cmap="coolwarm"` の部分を、次のようにいろいろ変えて描き比べてみよう。図の印象がどう変わるか観察すること。
>
> ```python
> for cmap in ["coolwarm", "seismic", "bwr", "RdBu", "viridis", "gray"]:
>     plt.imshow(V, extent=[-3, 3, -3, 3], origin="lower",
>                cmap=cmap, vmin=-2, vmax=2)
>     plt.colorbar(label="potential")
>     plt.title(f"cmap = {cmap}")
>     plt.savefig(f"potential_{cmap}.png")
>     plt.close()      # 次の図と重ならないように閉じる
> ```
>
> 正負の値を扱うこの例では、中央（0）を白にして正負を赤青で分ける **発散型（diverging）カラーマップ**（`coolwarm`, `seismic`, `bwr`, `RdBu`）が向いている。一方 `viridis` や `gray` のような **連続型** は、正負の符号が直感的に読み取りにくいことを確かめよう。**データの性質に合わせて `cmap` を選ぶ** ことが可視化では重要になる。

---

### 練習問題 7

以下の練習問題を `programing1/week10/` に `week10_practice7.py` として保存し、**提出すること**。各問題は `# %%` で区切ること。図はファイルに保存すること（`plt.savefig`）。

1. **2D 配列の作成とスライシング**: `np.arange(1, 26).reshape(5, 5)` で 1〜25 を 5 行 5 列に並べた配列 `a` を作れ。そのうえで、(a) 中央の要素 `a[2, 2]`、(b) 3 行目（`a[2, :]`）、(c) 4 列目（`a[:, 3]`）、(d) 左上 3×3 のブロック（`a[0:3, 0:3]`）をそれぞれ `print` で表示せよ。最後に、各列の合計（`a.sum(axis=0)`）も表示せよ。

2. **meshgrid と可視化**: x, y をともに −4〜4 の範囲で 200 点とり、`np.meshgrid` で格子を作れ。2 変数関数 z = sin(x)·cos(y) を全格子点で計算し、`contourf` と `colorbar` で等高線図を描いて `savefig` で保存せよ。さらに **同じ `Z` を `imshow`（`origin="lower"`, `extent` 指定）でも描き**、2 つの描き方の見た目の違いを確認せよ（別ファイルに保存）。
