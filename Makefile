# SPDX-FileCopyrightText: Copyright (c) 2020-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

.SHELLFLAGS=-e -o pipefail -c
.ONESHELL:
SHELL=bash
.PHONY: zip all test clean

all: paper.pdf zip

paper.pdf: paper.tex
	latexmk -pdf -latexoption=-interaction=errorstopmode -latexoption=-halt-on-error paper

zip: *.tex
	./zip-it.sh

clean:
	git clean -dfX
