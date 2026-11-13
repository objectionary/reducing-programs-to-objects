# SPDX-FileCopyrightText: Copyright (c) 2020-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

.SHELLFLAGS=-e -o pipefail -c
.ONESHELL:
SHELL=bash
.PHONY: zip all test clean

all: paper.pdf zip

paper.pdf: paper.tex $(wildcard sections/*.tex) $(wildcard bibliography/main.bib)
	latexmk -pdf -latexoption=-interaction=errorstopmode -latexoption=-halt-on-error paper

test:
	./tests/rebuilds-after-section-edit.sh

zip: *.tex
	./zip-it.sh

clean:
	git clean -dfX
