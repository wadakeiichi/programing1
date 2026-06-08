# Week 6　Matplotlib による 2D 可視化

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

更新が終わったら、自分の環境下に **`docs/week6.md` が存在すること** を必ず確認すること。VS Code 左側のエクスプローラーで `docs` フォルダを開き、`week6.md` が並んでいれば OK。または、ターミナルで次のコマンドを実行してファイルが表示されることを確認してもよい：

```bash
ls docs/week6.md
```

`docs/week6.md` が見つからない場合は、`make` が正しく実行できていない可能性があるので、プロンプトが `vscode ➜ /workspaces/programing1_student (main) $` になっているかを再確認し、もう一度 `make` を実行すること。

#### 自分の作業ファイル `week6.py` を作る

`docs` の更新が確認できたら、**授業用フォルダ（自分の作業フォルダ）の下** に `week6.py` という新しいファイルを作成する。VS Code のエクスプローラーで授業用フォルダを右クリック → 「新しいファイル」→ `week6.py` と入力すればよい。

今週も、解説中の **グレイ背景の Python コード** や 例１，２，… の例題部分を、この `week6.py` に **`# %%` 記法** を使って書き写しながら動作を試していく。`# %%` 記法とは、Python ファイルの中をセル単位に区切って実行できる VS Code の機能で、Jupyter Notebook のような対話的な実行ができる。書き方は次のとおり：

```python
# %%
# セル1：ライブラリを読み込む
import numpy as np
import matplotlib.pyplot as plt

# %%
# セル2：簡単なグラフを描いて保存する
x = np.linspace(0, 2 * np.pi, 100)
plt.plot(x, np.sin(x))
plt.savefig('test.png', dpi=150)
```

`# %%` の行が **セルの区切り** になる。各セルの上に表示される `Run Cell` をクリックする（または `Shift + Enter`）と、そのセルだけが実行され、結果がインタラクティブウィンドウに表示される。これにより、コード全体を最初から実行し直さずに、解説中のコード片を一つずつ試して動作を確認できる。

> **指示**: 以降に出てくるグレイ背景のコードは、**そのまま読むだけでなく、必ず `week6.py` に `# %%` で区切りながら入力して動作を確認すること**。例題部分（例１，例２，…）も同様に、自分で入力して試すこと。コピペではなく **自分の手で打ち込む** ことで身につく。

---

### 文法解説

#### 図（figure）と軸（axes）の関係 ― まず全体像をつかむ

Matplotlib のグラフは **2 段構造** になっている。最初にこの関係を理解しておくと、後の `ax.***` という書き方の意味がすぐ分かる。

- **figure（フィギュア）**: グラフ全体を載せる **「1 枚の紙」**。サイズ（`figsize`）や保存（`savefig`）は figure 単位で扱う。
- **axes（アクセス）**: その紙の上に置かれた **「1 つのグラフ領域」**。x 軸・y 軸を持ち、線・点・ラベルはこの axes に描かれる。1 枚の figure に axes を複数並べると「複数パネル」になる。

```
┌─────────── figure（紙全体）───────────┐
│  ┌──── axes ────┐   ┌──── axes ────┐  │
│  │   グラフ①    │   │   グラフ②    │  │
│  │  (x軸・y軸)   │   │  (x軸・y軸)   │  │
│  └──────────────┘   └──────────────┘  │
└───────────────────────────────────────┘
```

> **用語注意**: `axes` は「軸（axis）」の複数形に見えるが、Matplotlib では **「1 つのグラフ描画領域」** を指す専門用語。x 軸 1 本・y 軸 1 本を指す `axis` とは別物。

---

#### 基本的なグラフ（pyplot 方式）

まずは一番簡単な書き方。`plt.***` を順に呼ぶだけで、内部で「今アクティブな figure / axes」に描いてくれる。

```python
import matplotlib.pyplot as plt
import numpy as np

x = np.linspace(0, 2*np.pi, 100)
y = np.sin(x)

plt.figure(figsize=(8, 4))      # 図のサイズ（横, 縦）[インチ]
plt.plot(x, y)                   # 折れ線グラフ
plt.xlabel('x [rad]')           # 横軸ラベル（単位必須）
plt.ylabel('sin(x)')            # 縦軸ラベル
plt.title('サイン波')           # タイトル
plt.grid(True)                  # グリッド表示
plt.tight_layout()              # 余白自動調整
plt.savefig('sin.png', dpi=150) # ファイル保存（必須）
plt.show()                      # 画面表示
```

> **`figsize=(8, 4)` の意味**: 図の大きさを **（横幅, 高さ）インチ単位** で指定する。`(8, 4)` なら横長。`dpi=150`（dots per inch）と組み合わせると、保存される画像の解像度は **横 8×150 = 1200 px、縦 4×150 = 600 px** になる。グラフが詰まって見えるときは `figsize` を大きくする。

---

#### plot() のよく使うオプション

`plt.plot()` には線の見た目を変えるオプションを渡せる。物理のグラフでは複数の曲線を区別するために必須。

```python
plt.plot(x, y, color='red', linestyle='--', linewidth=2, label='sin')
plt.plot(x, z, color='blue', marker='.', markersize=3, label='cos')

plt.plot(x, y, 'r--')   # 省略記法：色＋線種をまとめて 'r--'（赤の破線）
plt.plot(x, z, 'b.')    # 省略記法：'b.'（青の点）
```

| オプション | 意味 | よく使う値 |
|-----------|------|-----------|
| `color`（`c`） | 線・点の色 | `'red'`, `'blue'`, `'black'`, `'b'`, `'#FF8800'` |
| `linestyle`（`ls`） | 線の種類 | `'-'`（実線）, `'--'`（破線）, `':'`（点線）, `'-.'`（一点鎖線） |
| `linewidth`（`lw`） | 線の太さ | `1`, `2`, `0.8` |
| `marker` | データ点の記号 | `'.'`（点）, `'o'`（丸）, `'s'`（四角）, `'^'`（三角） |
| `markersize`（`ms`） | 記号の大きさ | `3`, `5` |
| `label` | 凡例に表示する名前 | `'sin'`（`plt.legend()` で表示） |
| `alpha` | 透明度（0〜1） | `0.5`（重ね描きで便利） |

```python
# 凡例・軸範囲
plt.legend(loc='upper right')   # label を付けた線の凡例を表示
plt.xlim(0, 2*np.pi)            # 横軸の表示範囲
plt.ylim(-1.5, 1.5)            # 縦軸の表示範囲
```

> **省略記法のコツ**: `'r--'` のように **色 1 文字 + 線種** をまとめて書ける（`r`=赤, `g`=緑, `b`=青, `k`=黒）。点で描きたいときは `'b.'`、丸なら `'ro'`。慣れると速い。

---

#### 基準線を引く ― axhline() と axvline()

グラフに **水平線・垂直線** を 1 本引く関数。物理では「地面 y=0」「平衡点」「ピーク位置」などの基準を示すのに多用する。

```python
plt.axhline(y=0, color='black', linewidth=0.5)        # 横線（y = 0 の水平線）
plt.axvline(x=np.pi, color='gray', linestyle=':')     # 縦線（x = π の垂直線）
```

- **`axhline(y=...)`**: 指定した **y の高さ** に、グラフの左端から右端まで横一直線を引く（**h**orizontal line）。
- **`axvline(x=...)`**: 指定した **x の位置** に、グラフの下端から上端まで縦一直線を引く（**v**ertical line）。

`color`, `linestyle`, `linewidth` は `plot()` と同じオプションが使える。たとえばピーク波長 `peak` の位置を示すなら `plt.axvline(peak, color='red', linestyle='--')`。

---

#### 複数パネル ― subplots() と `ax.***` 記法

複数のグラフを並べるときは `plt.subplots(行数, 列数)` を使う。これは **figure と axes（複数）をまとめて作る** 関数で、戻り値は次の 2 つ。

```python
fig, axes = plt.subplots(1, 2, figsize=(12, 4))   # 1行2列 → axes は 2 個
#   ↑     ↑
#  figure  axes の配列（axes[0], axes[1] でアクセス）
```

ここで `axes[0]` のような **個々の axes に対して描く** ときは、`plt.plot()` ではなく **`ax.plot()` という書き方**（オブジェクト指向方式）を使う。「どのパネルに描くか」を `ax` で明示するためだ。

```python
fig, axes = plt.subplots(1, 2, figsize=(12, 4))

axes[0].plot(x, np.sin(x))         # 左パネルに描く
axes[0].set_xlabel('x [rad]')
axes[0].set_title('sin')

axes[1].plot(x, np.cos(x), color='red')   # 右パネルに描く
axes[1].set_xlabel('x [rad]')
axes[1].set_title('cos')

plt.tight_layout()
plt.savefig('subplots.png', dpi=150)
plt.show()
```

##### `ax.***` 記法の意味 ― pyplot 方式との対応

`ax`（= 1 つの axes）に対して `ax.メソッド名(...)` と書くと、**その特定のパネルだけ** に対して操作できる。`plt.***`（今アクティブなパネルに描く簡易方式）と機能は同じで、書き方が違うだけ。対応は次のとおり。

| pyplot 方式（簡易） | `ax.***` 方式（パネル指定） |
|--------------------|----------------------------|
| `plt.plot(...)` | `ax.plot(...)` |
| `plt.xlabel('x')` | `ax.set_xlabel('x')` |
| `plt.ylabel('y')` | `ax.set_ylabel('y')` |
| `plt.title('...')` | `ax.set_title('...')` |
| `plt.xlim(0, 10)` | `ax.set_xlim(0, 10)` |
| `plt.ylim(-1, 1)` | `ax.set_ylim(-1, 1)` |
| `plt.legend()` | `ax.legend()` |
| `plt.axhline(0)` | `ax.axhline(0)` |
| `plt.axvline(x)` | `ax.axvline(x)` |

> **ポイント**: ラベルやタイトルは pyplot 方式の `xlabel` が `ax` 方式では **`set_xlabel`（`set_` が付く）** になる点に注意。一方 `plot`・`legend`・`axhline`・`axvline` は名前が同じ。パネルが 1 つだけのときは `plt.***` で十分だが、**複数パネルを扱うときは `ax.***` 方式が必須**。

---

### 例 1 ― 斜方投射の軌跡（複数条件）

```python
# week6_ex1.py
import numpy as np
import matplotlib.pyplot as plt

g = 9.81       # m/s²
v0 = 20.0      # m/s

angles = [15, 30, 45, 60, 75]   # 仰角 [度]

plt.figure(figsize=(9, 5))

for theta_deg in angles:
    theta = np.radians(theta_deg)
    T_fly = 2 * v0 * np.sin(theta) / g          # 飛行時間
    t = np.linspace(0, T_fly, 200)
    x = v0 * np.cos(theta) * t
    y = v0 * np.sin(theta) * t - 0.5 * g * t**2
    plt.plot(x, y, label=f'θ = {theta_deg}°')

plt.axhline(0, color='black', linewidth=0.8, linestyle='--')
plt.xlabel('水平距離 x [m]')
plt.ylabel('高さ y [m]')
plt.title(f'斜方投射（初速度 {v0} m/s）')
plt.legend(loc='upper right')
plt.grid(True, alpha=0.4)
plt.tight_layout()
plt.savefig('projectile.png', dpi=150)
plt.show()
```

---

### 例 2 ― 正規分布のヒストグラムと理論曲線

```python
# week6_ex2.py
import numpy as np
import matplotlib.pyplot as plt

rng = np.random.default_rng(seed=42)   # 乱数ジェネレータ（seed 固定）

fig, axes = plt.subplots(1, 3, figsize=(13, 4))

for ax, N in zip(axes, [100, 1000, 10000]):
    samples = rng.normal(0, 1, N)

    ax.hist(samples, bins=40, density=True,
            alpha=0.6, color='steelblue', label='ヒストグラム')

    x = np.linspace(-4, 4, 200)
    y = np.exp(-x**2 / 2) / np.sqrt(2 * np.pi)
    ax.plot(x, y, 'r-', linewidth=2, label='理論値')

    ax.set_xlabel('x')
    ax.set_ylabel('確率密度')
    ax.set_title(f'N = {N:,}')
    ax.legend(fontsize=8)

plt.suptitle('標準正規分布のサンプリング', fontsize=13)
plt.tight_layout()
plt.savefig('normal_dist.png', dpi=150)
plt.show()
```

---

### 練習問題 3

以下の練習問題を `programing1/week6/` に `week6_practice3.py` として保存せよ。各問題は `# %%` で区切ること。

1. Week 5 の単振動 x(t) = 2 sin(t) をグラフにせよ。軸ラベルに単位を付け（"時間 t [s]"、"変位 x [m]"）、`grid` と `axhline(0)`（基準線）を付けて `harmonic.png` として保存せよ。

2. 斜方投射 θ = 15°, 30°, 45°, 60°, 75° を 1 つのグラフに重ねてプロットせよ。`label` と `legend` で各角度を区別し、グリッド・地面（`axhline(0)` の破線）を付けて `projectile.png` として保存せよ。

3. プランク分布（黒体放射）を `plt.subplots(1, 3)` で 3 温度（T = 3000, 6000, 15000 K）分、3 パネルに並べよ。各パネルでピーク波長を `axvline` で示し、`ax.set_xlabel` 等でラベルを付けて `spectrum.png` として保存せよ。

   波長 λ に対するプランクの放射式（分光放射輝度）は次式で与えられる:

   $$ B_\lambda(\lambda, T) = \frac{2hc^2}{\lambda^5} \cdot \frac{1}{\exp\!\left(\dfrac{hc}{\lambda k_B T}\right) - 1} $$

   ここで h = 6.626×10⁻³⁴ J·s（プランク定数）、c = 3.0×10⁸ m/s（光速）、k_B = 1.381×10⁻²³ J/K（ボルツマン定数）。波長は `np.linspace(100, 3000, 5000)` [nm] を `×1e-9` で [m] に直して計算し、ピーク波長は `np.argmax` で求めよ（Week 5 例 2 を参照）。
