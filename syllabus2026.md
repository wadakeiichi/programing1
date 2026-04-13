# プログラミングI　2026年度シラバス

**対象**: 物理・宇宙系 学部 2 年生
**形式**: 演習（全 15 回・各 90 分）
**環境**: VS Code + Dev Container（Python 3, NumPy, Matplotlib, SciPy）+ GitHub Copilot
**コーディング方式**: `.py` ファイル + `# %%` セル実行

---

## 授業の目標

1. CUI（コマンドライン）操作の基本を身につけ、プログラム開発環境を自力で整備できるようになる
2. Python の基本文法を習得し、物理・天文の計算を自力でプログラムできるようになる
3. NumPy・Matplotlib を用いたデータ処理・可視化ができるようになる
4. 常微分方程式の数値解法を理解し、物理シミュレーションを実装できるようになる
5. AI ツール（GitHub Copilot）をコード生成・デバッグに活用し、その出力を批判的に検証できるようになる

---

## 全 15 回の構成

### 前半：CUI 基礎 + Python 基礎（Week 1〜9）

| 回 | テーマ | 内容 | 教材・課題 |
|----|--------|------|-----------|
| 1 | **CUI 基礎（1）** | CUI と GUI の比較・ターミナル／PowerShell の起動・プロンプトの読み方・ディレクトリとパス（絶対／相対）・基本コマンド（pwd, ls, cd, mkdir, cp, mv, rm, cat） | `CUI実習_講義資料_Week1-2.pdf`（Week 1 部分）／練習問題 1〜3 |
| 2 | **CUI 基礎（2）＋環境設定** | シェルとは（bash／zsh／PowerShell）・シェルスクリプト基礎（変数・引数・if・for）・chmod・git clone による教材取得・VS Code 起動・Dev Container の構築と確認 | `CUI実習_講義資料_Week1-2.pdf`（Week 2 部分）・`初期設定ガイド2026ver1.pdf`／練習問題 1〜4 |
| 3 | **Python 入門＋書き方のルール** | `.py` ファイルの作成と `# %%` セル実行・数値演算・変数と型・コロン `:` の役割・インデントのルール・空白の使い方・コメント `#` の書き方・よくあるエラーの読み方 | `Python基礎_週別教材.md`・`week3b.md`／練習問題 0 |
| 4 | **Python 環境と基本的な数値計算** | 変数と型（int, float, complex, str）・算術演算子・print と f-string・リスト・タプル・for ループ・import と math モジュール | `week4.md`／練習問題 1 |
| 5 | **NumPy 配列とベクトル演算** | 配列と数学のベクトル・行列の関係・配列の作成（array, linspace, zeros, arange）・ブロードキャスト演算・集計関数（max, mean, sum）・for ループとの速度比較 | `week5.md`／練習問題 2 |
| 6 | **Matplotlib による 2D 可視化** | 折れ線グラフ（plot）・軸ラベル・凡例・グリッド・画像保存（savefig）・複数パネル（subplots）・ヒストグラム | `week6.md`／練習問題 3 |
| 7 | **制御構造と関数定義** | if／elif／else・for＋range・while（収束判定）・def による関数定義・デフォルト引数・docstring・自作モジュールの import | `week7.md`／練習問題 4 |
| 8 | **ファイル入出力とデータ解析** | CSV の読み書き（np.loadtxt・np.savetxt）・pandas の基本（pd.read_csv・列アクセス・条件絞り込み）・バイナリ保存（np.save／np.load）・辞書（dict）・glob によるバッチ処理と可視化 | `week8.md`／練習問題 5 |
| 9 | **NumPy 2D 配列と可視化** | 2D 配列の作成とスライシング・meshgrid の考え方・contourf（等高線）・imshow（ピクセルマップ）・colorbar | `week9.md`／練習問題 6 |

---

### 中盤：AI 活用実践（Week 10）

| 回 | テーマ | 内容 | 教材・課題 |
|----|--------|------|-----------|
| 10 | **AI 活用実践（1）：セットアップと基本操作** | GitHub Education Pack の申請・GitHub Copilot の有効化・インライン補完と Copilot Chat の使い方・AI にバグを探させる演習・自然言語からコードを生成させる演習・プロンプトの書き方の工夫・AI 出力の検証方法 | 別途配布 |

---

### 後半：数値計算・物理シミュレーション（Week 11〜15）

| 回 | テーマ | 内容 | 教材・課題 |
|----|--------|------|-----------|
| 11 | **常微分方程式の数値解法** | scipy.integrate.solve_ivp の使い方・2 階 ODE → 連立 1 階 ODE への変換・指数減衰（解析解との比較）・単振り子（小振幅と大振幅） | `week11.md`／練習問題 7 |
| 12 | **フィッティング・コマンドライン・バッチ処理** | scipy.optimize.curve_fit によるフィッティング・初期値の重要性・argparse によるコマンドライン引数・bash スクリプトによるパラメータスキャン | `week12.md`／練習問題 8 |
| 13 | **AI 活用実践（2）：数値計算 × AI** | Week 11 の ODE コードを Copilot Chat に説明させる・AI と協力してシミュレーションを拡張（空気抵抗付き斜方投射・減衰振動のパターン比較など）・結果の物理的解釈と発表 | 別途配布 |
| 14 | **復習・補足・質問対応** | Week 1〜13 の総復習・つまずきやすいポイントの補足解説・期末課題に向けた質問対応・未消化の練習問題のフォローアップ | なし（バッファ回） |
| 15 | **期末課題** | 教員指定の 2〜3 テーマから 1 問を選択して実装・提出（数値積分と誤差解析／ODE シミュレーション／フィッティングと可視化など） | 問題文は別途配布 |

---

## 教材一覧

| ファイル名 | 対応する回 | 内容 |
|-----------|-----------|------|
| `CUI実習_講義資料_Week1-2.pdf` | Week 1〜2 | CUI 基礎の講義資料・練習問題 |
| `初期設定ガイド2026ver1.pdf` | Week 2 | VS Code・Dev Container の初期設定手順 |
| `Python基礎_週別教材.md` | Week 3 | `.py` ファイルの作り方と `# %%` セル実行の説明 |
| `week3b.md` | Week 3 | コロン・インデント・空白のルール |
| `week4.md` | Week 4 | 変数・演算子・リスト・for ループ・import・math |
| `week5.md` | Week 5 | NumPy 配列の概念と演算 |
| `week6.md` | Week 6 | Matplotlib による 2D グラフ描画 |
| `week7.md` | Week 7 | if／for／while・関数定義・自作モジュール |
| `week8.md` | Week 8 | 辞書・ファイル入出力・バッチ処理 |
| `week9.md` | Week 9 | 2D 配列・meshgrid・contourf・imshow |
| `week11.md` | Week 11 | 常微分方程式の数値解法（solve_ivp） |
| `week12.md` | Week 12 | フィッティング（curve_fit）・argparse・bash |

---

## 評価方法

| 項目 | 配点 | 備考 |
|------|------|------|
| 随時課題（練習問題 0〜8） | 50% | 各回の練習問題を翌週の授業開始までに提出 |
| 期末課題（Week 15） | 50% | 指定テーマから 1 問選択して実装・提出 |

---

## AI 利用ポリシー

- 授業では **GitHub Copilot**（GitHub Education Pack で無料利用可）を標準 AI ツールとして使用する
- GitHub Copilot は VS Code 内でインライン補完（コードを書くと続きを提案）と Copilot Chat（チャット形式で質問・コード生成）の 2 つの機能を持つ
- Week 10 の AI 活用実践で GitHub Education Pack の申請と Copilot の有効化を行う（Week 1〜9 は AI なしで基礎を身につける）
- 練習問題・期末課題で AI を使用してよいが、以下のルールを守ること:
  1. AI が生成したコードを**理解せずにそのまま提出しない**
  2. AI の出力は必ず**自分で実行して検証する**
  3. AI を使用した箇所は**コメントで明記する**（例: `# Copilot で生成、修正済み`）

---

## 各週で新たに学ぶ主な文法・ツール

| 回 | 新出の文法・ツール |
|----|--------------------|
| 1 | pwd, ls, cd, mkdir, cp, mv, rm, cat |
| 2 | bash スクリプト, git clone, VS Code, Dev Container |
| 3 | `.py` ファイル, `# %%`, コロン `:`, インデント, コメント `#` |
| 4 | 変数, 型, 算術演算子, print, f-string, リスト `[]`, タプル `()`, for, import, math |
| 5 | np.array, np.linspace, np.zeros, np.arange, ブロードキャスト, np.max, np.mean |
| 6 | plt.plot, plt.xlabel, plt.legend, plt.savefig, plt.subplots, plt.hist |
| 7 | if/elif/else, while, range, def, return, デフォルト引数, 自作モジュール |
| 8 | dict `{}`, np.savetxt, np.loadtxt, np.save, np.load, glob, csv |
| 9 | 2D 配列, np.meshgrid, plt.contourf, plt.contour, plt.imshow, plt.colorbar |
| 10 | GitHub Education Pack, GitHub Copilot インライン補完, Copilot Chat |
| 11 | scipy.integrate.solve_ivp, ODE の連立化 |
| 12 | scipy.optimize.curve_fit, argparse, bash の for ループ |
| 13 | AI との協働パターン（問い → 生成 → 検証 → 発展） |
| 14 | （復習・補足） |
| 15 | （総合演習） |

---

## 前提知識

- Week 1〜2 はプログラミング経験不要（CUI 操作から始める）
- Week 4 以降は物理・数学の基礎知識を前提とする:
  - 力学（運動方程式、エネルギー保存、振動）
  - 線形代数（ベクトル、行列の基本）
  - 微分積分（微分方程式の初歩）

---

*2026 年度 プログラミング I　シラバス*
