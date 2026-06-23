#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Markdown 前処理: Pandoc + XeLaTeX でトーフ化する文字を事前変換する。

- 絵文字・dingbat（IPA/Noto にグリフ無し）→ テキスト等価物 or 削除
- ➜（U+279C, プロンプト矢印）→ ">"
- 下付き・上付き Unicode（v₀ の U+2080、²³ など）→ Pandoc 記法 ~0~ / ^2^
  （コードフェンス内は記法に変換せず、素の数字に置換する）

使い方:  python3 mdfix.py input.md > output.md
"""
import sys
import re

# --- 絵文字・dingbat の置換表 ---
EMOJI_MAP = {
    '🐳': '', '🪟': '', '🍎': '',
    '✅': '[OK]', '❌': '[NG]', '➜': '>',
    'ℹ': '', '⚠': '注意 ', '✔': '[OK]', '✖': '[NG]',
}

# --- 下付き・上付き Unicode → 素の文字 ---
SUP = {'²': '2', '³': '3', '¹': '1', '⁰': '0', '⁴': '4', '⁵': '5',
       '⁶': '6', '⁷': '7', '⁸': '8', '⁹': '9', 'ⁿ': 'n', '⁺': '+', '⁻': '-'}
SUB = {chr(0x2080 + d): str(d) for d in range(10)}
SUB.update({'₊': '+', '₋': '-', 'ₙ': 'n', 'ₖ': 'k', 'ᵢ': 'i'})

SUP_RE = re.compile('[' + ''.join(re.escape(c) for c in SUP) + ']+')
SUB_RE = re.compile('[' + ''.join(re.escape(c) for c in SUB) + ']+')


def strip_emoji(text):
    for k, v in EMOJI_MAP.items():
        text = text.replace(k, v)
    out = []
    for ch in text:
        o = ord(ch)
        if (0x1F000 <= o <= 0x1FAFF) or (0x2600 <= o <= 0x27BF) or o == 0xFE0F:
            continue  # 残った絵文字は削除（トーフ防止）
        out.append(ch)
    return ''.join(out)


def to_pandoc_supersub(text):
    """本文行用: 上付き → ^..^、下付き → ~..~（Pandoc 記法）"""
    text = SUP_RE.sub(lambda m: '^' + ''.join(SUP[c] for c in m.group(0)) + '^', text)
    text = SUB_RE.sub(lambda m: '~' + ''.join(SUB[c] for c in m.group(0)) + '~', text)
    return text


def to_plain_supersub(text):
    """コード行用: 記法を使わず素の数字へ"""
    text = SUP_RE.sub(lambda m: ''.join(SUP[c] for c in m.group(0)), text)
    text = SUB_RE.sub(lambda m: ''.join(SUB[c] for c in m.group(0)), text)
    return text


def main():
    src = sys.stdin.read() if len(sys.argv) < 2 else open(sys.argv[1], encoding='utf-8').read()
    in_fence = False
    out = []
    for line in src.split('\n'):
        if line.lstrip().startswith('```'):
            in_fence = not in_fence
            out.append(strip_emoji(line))
            continue
        line = strip_emoji(line)
        line = to_plain_supersub(line) if in_fence else to_pandoc_supersub(line)
        out.append(line)
    sys.stdout.write('\n'.join(out))


if __name__ == '__main__':
    main()
