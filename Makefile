
DOC=chisel-book
DOC_CN=chisel-book_CN

all: test gencode fig book genslides

#	scala scripts/gencode.scala

test:
	sbt test

gencode:
	-mkdir code
	sbt -Dsbt.main.class=sbt.ScriptMain scripts/gencode.scala

fig:
	make -C figures

book: gencode fig
	pdflatex $(DOC)
	bibtex $(DOC)
	makeindex $(DOC)
	pdflatex $(DOC)
	pdflatex $(DOC)

cn: gencode fig
	xelatex $(DOC_CN)
	bibtex $(DOC_CN)
	makeindex $(DOC_CN)
	xelatex $(DOC_CN)
	xelatex $(DOC_CN)
	
genslides:
	cd slides; ./doslides.sh

veryclean:
	git clean -fd

clean:
	rm -fr *.aux *.bbl *.blg *.log *.lof *.lot *.toc *.gz *.lol # *.pdf
	rm -rf code
	rm -rf test_run_dir

chisel:
	sbt "runMain Snippets"
	sbt "runMain Counter"
	sbt "test:runMain RegisterTester"
	sbt "test:runMain LogicTester"

# test only one
flasher:
	sbt "testOnly FlasherSpec"

rtf:
	latex2rtf chisel-book.tex

detex:
	detex chisel-book.tex > chisel-book.txt

eclipse:
	sbt eclipse

chisel2_test:
	cd chisel2; sbt "runMain RegisterTester"
	cd chisel2; sbt "runMain LogicTester"

chisel2_hw:
	cd chisel2; sbt "runMain LogicHardware"
