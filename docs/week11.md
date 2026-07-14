# Week 11　常微分方程式の数値解法

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
ls docs/week11.md
```

更新を確認したら、*授業用フォルダに* `week11.py` を作り、解説中のコードを **`# %%` 記法** で書き写しながら試すこと。

```python
# %%
# セル1：solve_ivp の最小例（指数減衰 dy/dt = -k y）
import numpy as np
from scipy.integrate import solve_ivp

def rhs(t, y):
    k = 0.5
    return -k * y

sol = solve_ivp(rhs, [0, 10], [1.0], t_eval=np.linspace(0, 10, 11))
print(sol.t)
print(sol.y[0])
```

---

### 今週のテーマ ― 微分方程式を「数値で」解く

物理の基本法則の多くは **微分方程式** で書かれる。運動方程式 F = ma は加速度（位置の 2 階微分）を含む微分方程式であり、放射性崩壊・熱伝導・振動・軌道運動などもすべて微分方程式で表される。

解析的に解ける微分方程式は限られている。そこで、コンピュータで **数値的に** 解く。今週は SciPy の **`scipy.integrate.solve_ivp`**（solve initial value problem = 初期値問題を解く）を使い、微分方程式を時間発展させて解を得る方法を学ぶ。

| やること | 使う道具 |
|---------|---------|
| 微分方程式を関数で表す | `def rhs(t, y): return dydt` |
| 初期値問題を解く | `solve_ivp(rhs, [t0, t1], [y0], t_eval=...)` |
| 解を取り出す | `sol.t`（時刻）・`sol.y`（各変数の値） |
| 2 階の方程式を扱う | 連立 1 階に変換して `y = [位置, 速度]` |

---

### 文法解説

#### 初期値問題と solve_ivp

**初期値問題** とは、「ある時刻 t₀ での値（初期値）が分かっているとき、そこから微分方程式に従って時間発展させる」問題。`solve_ivp` は次の形で使う。

```python
# 【書き方の型】← そのまま実行しないこと（下の「動く最小の例」を打ち込むこと）
from scipy.integrate import solve_ivp

def rhs(t, y):
    # dy/dt を計算して返す（y は現在の状態）
    return dydt                                    # ← 実際は具体的な式を書く

sol = solve_ivp(rhs, [t0, t1], [y0], t_eval=時刻の配列)   # ← t0, t1, y0 は仮の名前
```

> **⚠ 上のコードは「書き方の型」であり、そのままでは動きません。** `t0`・`t1`・`y0`・`dydt`・`時刻の配列` はすべて **仮の名前** なので、実行すると `NameError: name 't0' is not defined` などになります。**打ち込んで動かすのは、下の「動く最小の例」から** にしてください。

- **`rhs(t, y)`**: 右辺（right-hand side）。**現在の時刻 t と状態 y から、微分 dy/dt を返す** 関数。
- **`[t0, t1]`**: 積分する時間の区間（開始・終了）。
- **`[y0]`**: 初期値（リストで渡す）。
- **`t_eval`**: 解を評価してほしい時刻の配列（省略可だが、グラフ用に指定すると便利）。

#### 結果の取り出し方 ― `sol.t` と `sol.y[0]`

`solve_ivp` は、計算結果を **`sol` という「入れ物」（オブジェクト）にまとめて** 返す。中には「時刻の配列」「解の配列」など複数の結果が入っている。その中身を取り出すのが **`.`（ドット）** の書き方。

これは新しい記法ではなく、**すでに使ってきたものと同じ** である。

| すでに使った例 | 意味 |
|---------------|------|
| `df.shape`（Week 9） | 表 `df` の中の「形」を取り出す |
| `a.shape`（Week 10） | 配列 `a` の中の「形」を取り出す |
| `sol.t`（今回） | 結果 `sol` の中の「時刻の配列」を取り出す |
| `sol.y`（今回） | 結果 `sol` の中の「解の配列」を取り出す |

つまり **`もの.名前` で「そのものが持っている値」を取り出す**、と覚えればよい。

次に、**`sol.y` は 2 次元配列**（Week 10）である点が重要。**行が「変数」、列が「時刻」** に対応する。

```
              時刻 →   t[0]   t[1]   t[2] ...
sol.y[0]  1つ目の変数   y0(t0) y0(t1) y0(t2) ...
sol.y[1]  2つ目の変数   y1(t0) y1(t1) y1(t2) ...
```

したがって **`sol.y[0]` は「0 行目 ＝ 1 つ目の変数の時間変化」**。Week 10 で学んだカンマの書き方でいえば **`sol.y[0]` は `sol.y[0, :]` と同じ**（行番号だけ書くと、その行がまるごと取り出される）。変数が 2 つある場合は `sol.y[0]`（位置）・`sol.y[1]`（速度）のように使う。

次が **実際に動く最小の例**（dy/dt = −0.5·y を解く）。`sol.y` の形を `shape` で確かめながら進める。ここからは `week11.py` に打ち込んで実行すること。

```python
# 動く最小の例
import numpy as np
from scipy.integrate import solve_ivp

def rhs(t, y):
    return -0.5 * y      # dy/dt = -k y （k = 0.5）

sol = solve_ivp(rhs, [0, 10], [1.0], t_eval=np.linspace(0, 10, 100))

print(sol.t.shape)       # (100,)   ← 時刻が 100 個
print(sol.y.shape)       # (1, 100) ← 「変数 1 個 × 時刻 100 個」の 2 次元配列

t = sol.t
y = sol.y[0]             # 0 行目＝1 つ目の変数（sol.y[0, :] と同じ）
print(t[:3])
print(y[:3])
```

> **ポイント**: `sol.y.shape` を `print` してみると、`(変数の数, 時刻の数)` になっていることが確かめられる。変数が 1 つでも `sol.y` は 2 次元のままなので、**`[0]` を付けて 1 次元の配列にしてからグラフに渡す** 必要がある。

#### 1 階の微分方程式 ― 指数減衰

いちばん簡単な例は dy/dt = −k·y（放射性崩壊など）。解析解は y(t) = y₀·exp(−k·t) なので、数値解と比較して確かめられる。

```python
def rhs(t, y):
    k = 0.5
    return -k * y      # dy/dt = -k y
```

#### 2 階の微分方程式 ― 連立 1 階への変換

運動方程式のように **2 階微分** を含む式は、そのままでは `solve_ivp` に渡せない。**変数を増やして連立 1 階に変換** する。

例えば単振動 d²x/dt² = −ω²·x は、速度 v = dx/dt を新しい変数として導入すると、

- dx/dt = v
- dv/dt = −ω²·x

という **2 本の 1 階の方程式** になる。状態を `y = [x, v]` とまとめれば、`rhs` はこの 2 成分を返せばよい。

```python
def rhs(t, y):
    x, v = y              # 状態を分解
    omega = 2.0
    dxdt = v
    dvdt = -omega**2 * x
    return [dxdt, dvdt]   # [dx/dt, dv/dt] を返す

sol = solve_ivp(rhs, [0, 10], [1.0, 0.0], t_eval=np.linspace(0, 10, 200))
x = sol.y[0]    # 位置
v = sol.y[1]    # 速度
```

> **ポイント**: 2 階 → 連立 1 階の変換は数値計算の基本テクニック。「位置と速度をまとめて状態ベクトルにする」と覚える。n 階の方程式なら n 個の 1 階方程式になる。

---

### 例 1 ― 放射性崩壊（1 階 ODE・解析解と比較）

dy/dt = −k·y を解き、解析解 y = y₀·exp(−k·t) と重ねて、数値解が正しいことを確認する。

```python
# week11_ex1.py
import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp

k = 0.5
def rhs(t, y):
    return -k * y

t_eval = np.linspace(0, 10, 100)
sol = solve_ivp(rhs, [0, 10], [1.0], t_eval=t_eval)

# 解析解
y_exact = 1.0 * np.exp(-k * t_eval)

plt.plot(sol.t, sol.y[0], "o", markersize=3, label="solve_ivp")
plt.plot(t_eval, y_exact, "-", label="exact: exp(-k t)")
plt.xlabel("time")
plt.ylabel("y")
plt.legend()
plt.title("Radioactive decay")
plt.savefig("decay.png")
plt.show()

# 数値解と解析解の最大誤差
err = np.max(np.abs(sol.y[0] - y_exact))
print(f"最大誤差: {err:.2e}")
```

**実行結果の確認ポイント**: `decay.png` で数値解（点）と解析解（線）がぴったり重なること。最大誤差が十分小さい（`solve_ivp` の既定精度でおよそ 10⁻⁴ 以下）ことを確認する。より高精度にしたいときは `solve_ivp(..., rtol=1e-8, atol=1e-10)` のように許容誤差を指定できる。

---

### 例 2 ― 単振り子（2 階 ODE・小振幅と大振幅）

振り子の運動 d²θ/dt² = −(g/L)·sin(θ) を連立 1 階に変換して解く。**小振幅では sin(θ) ≈ θ の単振動** に近いが、**大振幅ではずれる** ことを可視化する。

```python
# week11_ex2.py
import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp

g, L = 9.81, 1.0

def pendulum(t, y):
    theta, omega = y                 # 角度, 角速度
    dtheta = omega
    domega = -(g / L) * np.sin(theta)
    return [dtheta, domega]

t_eval = np.linspace(0, 10, 500)

# 初期角度を変えて 2 通り解く（小振幅・大振幅）
for theta0, label in [(0.2, "small (0.2 rad)"), (2.5, "large (2.5 rad)")]:
    sol = solve_ivp(pendulum, [0, 10], [theta0, 0.0], t_eval=t_eval)
    plt.plot(sol.t, sol.y[0], label=label)

plt.xlabel("time [s]")
plt.ylabel("angle [rad]")
plt.legend()
plt.title("Pendulum: small vs large amplitude")
plt.grid(True)
plt.savefig("pendulum.png")
plt.show()
```

**実行結果の確認ポイント**: `pendulum.png` で 2 本の曲線が描かれ、**大振幅の方が周期が長い**（単振動からずれる）ことが読み取れれば成功。連立 1 階に変換した `pendulum` が `[dθ/dt, dω/dt]` を返している点に注目する。

---

### 練習問題 8

以下の練習問題を `programing1/week11/` に `week11_practice8.py` として保存し、**提出すること**。各問題は `# %%` で区切ること。図は `plt.savefig` で保存すること。

1. **1 階 ODE と解析解の比較**: 微分方程式 dy/dt = −k·y を k = 1.0、初期値 y₀ = 2.0、区間 [0, 5] で `solve_ivp` を使って解け。解析解 y = y₀·exp(−k·t) と同じグラフに重ねて描き、数値解と解析解の **最大誤差** を `print` で表示せよ。

2. **2 階 ODE（減衰振動）**: 減衰のある振動 d²x/dt² = −ω²·x − 2γ·(dx/dt) を、ω = 2.0、γ = 0.2、初期値 x₀ = 1.0・v₀ = 0.0、区間 [0, 20] で解け（連立 1 階に変換すること）。位置 x の時間変化をグラフに描き、**振幅が時間とともに小さくなっていく** ことを確認せよ。
