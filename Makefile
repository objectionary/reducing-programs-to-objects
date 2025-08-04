# SPDX-FileCopyrightText: Copyright (c) 2020-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

.SHELLFLAGS=-e -x -o pipefail -c
.ONESHELL:

TLROOT=$$(kpsewhich -var-value TEXMFDIST)
PACKAGES=ffcode to-be-determined href-ul eolang
REPO=objectionary/reducing-programs-to-objects

zip: *.tex
	rm -rf package
	mkdir package
	cd package
	cp ../paper.tex .
	mkdir -p bibliography
	cp ../bibliography/main.bib ./bibliography/main.bib
	cp ../goto-pic.pdf .
	for p in $(PACKAGES); do
		cp "$(TLROOT)/tex/latex/$${p}/$${p}.sty" .
	done
	version=$$(curl --silent -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/$(REPO)/releases/latest" | jq -r '.tag_name')
	echo "Version is: $${version}"
	gsed -i "s|0\.0\.0|$${version}|" paper.tex
	gsed -i "s|REPOSITORY|$(REPO)|" paper.tex
	pdflatex -shell-escape -halt-on-error paper.tex
	biber paper
	pdflatex -halt-on-error paper.tex
	pdflatex -halt-on-error paper.tex
	rm -rf ./*.aux ./*.bcf ./*.blg ./*.fdb_latexmk ./*.fls ./*.log ./*.run.xml ./*.out ./*.exc
	zip -x paper.pdf -r "paper-$${version}.zip" *
	mv "paper-$${version}.zip" ..
	cd ..

clean:
	git clean -dfX
