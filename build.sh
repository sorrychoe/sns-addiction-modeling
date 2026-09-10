#!/usr/bin/env bash

set -euo pipefail
BASE=sns_addiction_regression

# 1. jupytext source -> notebook, then execute in place
jupyter nbconvert --to notebook --execute --inplace \
    --ExecutePreprocessor.timeout=600 "$BASE.ipynb"

# 2. notebook -> LaTeX (nbconvert omits the CJK package, so add it)
rm -rf "${BASE}_files" "$BASE.tex"
jupyter nbconvert --to latex --output "$BASE" "$BASE.ipynb"
python3 - "$BASE.tex" <<'PY'
import sys
p = sys.argv[1]
s = open(p, encoding="utf-8").read()
doc = r"\documentclass[11pt]{article}"
# kotex right after \documentclass; newunicodechar must load *after* fontspec,
# so inject the symbol fallbacks just before \begin{document}.
if r"\usepackage{kotex}" not in s:
    s = s.replace(doc, doc + "\n" + r"\usepackage{kotex}", 1)
fallbacks = r"""\usepackage{newunicodechar}
\newunicodechar{≈}{\ensuremath{\approx}}
\newunicodechar{≟}{\ensuremath{\stackrel{?}{=}}}
\newunicodechar{≤}{\ensuremath{\leq}}
\newunicodechar{≥}{\ensuremath{\geq}}
\newunicodechar{≠}{\ensuremath{\neq}}
\newunicodechar{≪}{\ensuremath{\ll}}
\newunicodechar{≫}{\ensuremath{\gg}}
\newunicodechar{β}{\ensuremath{\beta}}
\newunicodechar{√}{\ensuremath{\sqrt{}}}
\newunicodechar{×}{\ensuremath{\times}}
\newunicodechar{±}{\ensuremath{\pm}}
\newunicodechar{→}{\ensuremath{\rightarrow}}
\newunicodechar{∈}{\ensuremath{\in}}
\newunicodechar{²}{\textsuperscript{2}}
\newunicodechar{₀}{\textsubscript{0}}
\newunicodechar{₁}{\textsubscript{1}}

\begin{document}"""
if r"\newunicodechar" not in s:
    s = s.replace(r"\begin{document}", fallbacks, 1)
open(p, "w", encoding="utf-8").write(s)
PY

# 3. LaTeX -> PDF (twice for cross-references)
xelatex -interaction=nonstopmode -halt-on-error "$BASE.tex"
xelatex -interaction=nonstopmode -halt-on-error "$BASE.tex"

# 4. tidy build artifacts
rm -fr "${BASE}_files"
rm -f "$BASE".{aux,log,fls,out,synctex.gz}
echo "Done: $BASE.ipynb, $BASE.tex, $BASE.pdf"
