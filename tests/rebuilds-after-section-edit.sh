#!/usr/bin/env bash
# SPDX-FileCopyrightText: Copyright (c) 2020-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

set -e -o pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
temp=$(mktemp -d)
trap 'rm -rf "${temp}"' EXIT
mkdir "${temp}/sections" "${temp}/bibliography"
cp "${root}/Makefile" "${temp}/Makefile"
touch "${temp}/paper.tex" "${temp}/sections/features.tex" "${temp}/bibliography/main.bib"
touch "${temp}/paper.pdf"
touch "${temp}/sections/features.tex"
if ! make -C "${temp}" -n paper.pdf | grep -q latexmk; then
  echo "Editing sections/features.tex did not trigger latexmk" >&2
  exit 1
fi
touch "${temp}/paper.pdf"
touch "${temp}/bibliography/main.bib"
if ! make -C "${temp}" -n paper.pdf | grep -q latexmk; then
  echo "Editing bibliography/main.bib did not trigger latexmk" >&2
  exit 1
fi
