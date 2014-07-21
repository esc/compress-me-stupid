base = slides
slidefilename = haenel-ep14-compress-me-stupid

.PHONY: git-sha

all: $(base).pdf

git-sha:
	echo `git describe --tags --always --dirty` > git-sha

$(base).pdf: $(base).tex $(base).rst
	pandoc -t beamer slides.rst -o slides.tex --filter ./pygments.hs -H borland-defs.tex --template beamer_template.tex
	make git-sha
	sed s/begin{frame}/begin{frame}[fragile]/ ${base}.tex > ${base}-fragile.tex
	pdflatex $(base)-fragile.tex
	pdflatex $(base)-fragile.tex
	mv ${base}-fragile.pdf ${base}.pdf
	cp slides.pdf "$(slidefilename)"-`cat git-sha`.pdf

$(base).tex: $(base).rst

clean:
	-rm -vf $(addprefix $(base).,toc snm log aux out nav)

distclean: clean
	-rm -vf $(base).pdf $(base)-fragile.tex "$(slidefilename)"-`cat git-sha`.pdf git-sha
