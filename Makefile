######################
#      Makefile      #
######################

CHAPTERS_DIR = chapters/
CHAPTERS = *.md
ABSTRACTS_DIR = abstracts/
ABSTRACTS = *.md
FILE_NAME = bachelorthesis

PANDOC = pandoc

#
OPTIONS = --latex-engine=xelatex --filter pandoc-crossref --filter pandoc-citeproc --filter pandoc-citeproc-preamble -M citeproc-preamble=template/pages/bibliography_preamble.tex --template tmp/template.tex
ABSTRACT_OPTIONS = --latex-engine=xelatex --filter pandoc-crossref --filter pandoc-citeproc

all: clean pdf show

pdf: mk_build template abstract
	$(PANDOC) $(OPTIONS) $(CHAPTERS_DIR)$(CHAPTERS) -o build/$(FILE_NAME).pdf

abstract: mk_tmp
	$(PANDOC) $(ABSTRACT_OPTIONS) $(ABSTRACTS_DIR)$(ABSTRACTS) -o tmp/abstract.tex

show: build/$(FILE_NAME).pdf
	open build/$(FILE_NAME).pdf &

mk_build:
	mkdir -p build

mk_tmp:
	mkdir -p tmp

template: build_template #copy_university_logos

build_template: mk_tmp
	cat template/pandoc.tex \
	| sed -e 's/\\input{\(.*\)}/\\input{template\/\1}/g' \
		-e 's/template\/pages\/abstract/tmp\/abstract/g' \
	> tmp/template.tex

copy_university_logos:
	cp logos/* template/logos

clean:
	rm -f build/$(FILE_NAME).*

purge:
	rm -rf build tmp

.PHONY: clean purge
