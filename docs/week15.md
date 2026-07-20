# 補講 2（Week 15）　C 言語入門 ― Python と比べて学ぶ（後半）

> **この教材は補講用です。** 通常のシラバス（全 13 回）には含まれず、成績評価の対象外です。補講 1（Week 14）の続きとして、**配列** と **ファイル入出力** を Python と比べながら学びます。補講 1 の内容（コンパイル・`gcc` での実行・基本文法・if・ループ）を前提とします。

> **Dev Container の確認**: いつも通り **dev container 環境下** の VS Code で作業する。補講 1 で作った `week14_c/` と同様に、今回は `week15_c/` フォルダを作り、その中に `.c` ファイルを置く。コンパイルと実行は補講 1 と同じ：
>
> ```bash
> gcc プログラム名.c -o 出力名
> ./出力名
> ```

---

### 配列 ― 同じ型の値を並べて持つ

Python では `list`（`[1, 2, 3]`）や NumPy 配列で複数の値をまとめて扱った。C にも **配列（array）** があるが、いくつか重要な違いがある。

```python
# Python：リスト
a = [10, 20, 30, 40, 50]
print(a[0])        # 10
print(len(a))      # 5
a.append(60)       # 要素を後から追加できる
```

```c
/* C：配列 */
int a[5] = {10, 20, 30, 40, 50};   /* 大きさ 5 の int 配列 */
printf("%d\n", a[0]);              /* 10 */
```

C の配列の特徴（Python のリストとの違い）：

- **型と大きさを最初に決める**: `int a[5]` は「int を 5 個」。**あとから大きさは変えられない**（`append` のような操作はない）。
- **同じ型の要素だけ**: Python のリストは数値と文字列を混ぜられたが、C の配列は **全要素が同じ型**。
- **添字は 0 から**: `a[0]` が先頭。ここは Python と同じ。
- **`len()` がない**: 配列自身は長さを覚えていない。**大きさは自分で管理** する（別の変数に入れておく）。

#### 配列とループ ― 合計を求める

配列の全要素を処理するには `for` を使う。**要素数を変数に持っておく** のが定石。

```python
# Python
a = [10, 20, 30, 40, 50]
total = 0
for x in a:
    total += x
print(total)       # 150
```

```c
/* C */
int a[5] = {10, 20, 30, 40, 50};
int n = 5;                 /* 要素数を自分で持つ */
int total = 0;
for (int i = 0; i < n; i++) {
    total += a[i];         /* 添字でアクセス */
}
printf("%d\n", total);     /* 150 */
```

> **注意**: C では配列の範囲外（例えば `a[5]` や `a[100]`）にアクセスしてもエラーで止まらず、**でたらめな値を読んだり、プログラムが壊れたり** する。Python のように親切に「範囲外です」と教えてくれない。**添字が `0` 〜 `n-1` の範囲に収まっているか** を自分で注意すること。

---

### ファイル入出力 ― ファイルに書く・読む

Week 8 で Python の `open` を学んだ。C でも考え方は同じ「**開く → 読み書き → 閉じる**」だが、書き方が異なる。C では **`FILE` 型のポインタ** を使い、`fopen` で開き、`fprintf`／`fscanf` で読み書きし、`fclose` で閉じる。

#### ファイルに書き出す ― fopen / fprintf / fclose

```python
# Python：ファイルに書く
with open("data.txt", "w") as f:
    for i in range(1, 6):
        f.write(f"{i} {i*i}\n")
```

```c
/* C：ファイルに書く */
#include <stdio.h>

int main(void) {
    FILE *f = fopen("data.txt", "w");   /* "w" = 書き込みモードで開く */
    if (f == NULL) {                    /* 開けなかったときの確認 */
        printf("ファイルを開けません\n");
        return 1;
    }
    for (int i = 1; i <= 5; i++) {
        fprintf(f, "%d %d\n", i, i * i);   /* ファイルへ書式付きで書く */
    }
    fclose(f);                          /* 必ず閉じる */
    return 0;
}
```

- **`fopen("data.txt", "w")`**: ファイルを開く。`"w"` は書き込み（write）、`"r"` は読み込み（read）。
- **`FILE *f`**: 開いたファイルを指す **ポインタ**。以降の読み書きでこれを使う。
- **`if (f == NULL)`**: 開けなかった場合 `fopen` は `NULL` を返す。**開けたか必ず確認** する習慣をつける。
- **`fprintf(f, ...)`**: `printf` の「ファイル版」。第 1 引数にファイルを渡す以外は `printf` と同じ書式。
- **`fclose(f)`**: 使い終わったら閉じる。Python の `with` は自動で閉じたが、**C では自分で閉じる**。

#### ファイルから読み込む ― fopen / fscanf / fclose

```python
# Python：ファイルを読む
with open("data.txt", "r") as f:
    for line in f:
        a, b = line.split()
        print(int(a), int(b))
```

```c
/* C：ファイルを読む */
#include <stdio.h>

int main(void) {
    FILE *f = fopen("data.txt", "r");   /* "r" = 読み込みモード */
    if (f == NULL) {
        printf("ファイルを開けません\n");
        return 1;
    }
    int a, b;
    /* fscanf は読み取れた個数を返す。2 個読める間くり返す */
    while (fscanf(f, "%d %d", &a, &b) == 2) {
        printf("%d %d\n", a, b);
    }
    fclose(f);
    return 0;
}
```

- **`fscanf(f, "%d %d", &a, &b)`**: ファイルから書式に従って読む。読み込む変数には **`&`（アドレス演算子）** を付ける（`&a` は「a の置き場所」の意味）。
- **戻り値** は読み取れた項目数。`== 2` の間くり返すことで、**ファイルの終わりまで** 読める。

> **ポイント**: C のファイル入出力は「`fopen` で開く → `fprintf`/`fscanf` で書式付きに読み書き → `fclose` で閉じる」。Python の `open`／`with` と対応づけて覚えるとよい。`&` を付け忘れる・`fclose` を忘れる、が定番のミス。

---

### 例 ― 計算結果をファイルに保存して読み戻す

Week 8（Python）でやった「計算 → 保存 → 読み込み」を C で書く。1〜5 とその 2 乗を書き出し、別プログラムで読み戻して合計する。

```c
/* week15_c/write.c ― 書き出し */
#include <stdio.h>

int main(void) {
    FILE *f = fopen("squares.txt", "w");
    if (f == NULL) { printf("開けません\n"); return 1; }
    for (int i = 1; i <= 5; i++) {
        fprintf(f, "%d %d\n", i, i * i);
    }
    fclose(f);
    printf("squares.txt に書き出しました\n");
    return 0;
}
```

```c
/* week15_c/read.c ― 読み込みと合計 */
#include <stdio.h>

int main(void) {
    FILE *f = fopen("squares.txt", "r");
    if (f == NULL) { printf("開けません\n"); return 1; }
    int i, sq;
    int total = 0;
    while (fscanf(f, "%d %d", &i, &sq) == 2) {
        printf("%d の 2 乗 = %d\n", i, sq);
        total += sq;
    }
    fclose(f);
    printf("2 乗の合計 = %d\n", total);
    return 0;
}
```

コンパイルして順に実行する。

```bash
gcc write.c -o write
gcc read.c -o read
./write        # squares.txt を作る
./read         # squares.txt を読んで合計を出す
```

**実行結果の確認ポイント**: `./write` で `squares.txt` ができ、`./read` が各行を表示して `2 乗の合計 = 55`（1+4+9+16+25）と出れば成功。**write を先に実行しないと read するファイルが無い** ことに注意（Week 9 の「例 1 を先に実行」と同じ考え方）。

---

### まとめ ― Python と C の対応表

これまでの内容を対応づけておく。**考え方は共通、書き方が違う** ことが分かる。

| やること | Python | C |
|---------|--------|---|
| 実行 | `python a.py`（そのまま実行） | `gcc a.c -o a` → `./a`（コンパイル後実行） |
| 表示 | `print(x)` | `printf("%d\n", x);` |
| 変数 | `n = 10`（型は自動） | `int n = 10;`（型を宣言） |
| 文の区切り | 改行 | `;`（セミコロン） |
| ブロック | インデント | `{ }`（波かっこ） |
| コメント | `#` | `//` または `/* */` |
| 条件分岐 | `if / elif / else` | `if / else if / else`（条件は `( )`） |
| 論理演算 | `and` / `or` / `not` | `&&` / \|\| / `!` |
| 繰り返し | `for i in range(5):` | `for (int i=0; i<5; i++)` |
| 配列・リスト | `a = [..]`（可変長） | `int a[5] = {..};`（固定長・同型） |
| 要素数 | `len(a)` | 自分で管理する |
| ファイル書き | `open("f","w")` → `f.write(...)` | `fopen("f","w")` → `fprintf(...)` → `fclose` |
| ファイル読み | `open("f","r")` → `for line in f` | `fopen("f","r")` → `fscanf(...)` → `fclose` |

> **まとめのポイント**: Python で身につけた **アルゴリズムの考え方**（順次・分岐・反復・データの読み書き）は、そのまま C でも通用する。C を学ぶと「コンパイル」「型」「メモリ（配列の範囲・ポインタ `&`）」といった、**コンピュータの動く仕組みにより近い視点** が得られる。

---

### 補講課題 2（任意・提出不要）

理解の確認用。提出は不要だが、実際にコンパイル・実行して動かしてみること。

1. **配列の最大値**: 大きさ 6 の int 配列 `{3, 1, 4, 1, 5, 9}` を用意し、`for` ループで **最大値** を求めて表示する C プログラム `maxval.c` を書け。同じ処理を Python でも書き、配列の扱いの違い（固定長・要素数の管理）をコメントで説明せよ。

2. **ファイルに保存**: 1 から 10 までの整数と、その **3 乗** を各行に書き出す C プログラム `cubes.c` を書け（`fopen`/`fprintf`/`fclose` を使う）。実行後、できたファイルを VS Code で開いて中身を確認し、さらに別プログラムまたは Python でそのファイルを読み込んで表示してみよ。
