.SUFFIXES: .pdf .show .tex .view

listen_files := Makefile *.sty
tex_sources != echo *.tex 2>/dev/null
pdf_targets := $(tex_sources:.tex=.pdf)

#_# TARGET.pdf
#_#   Make PDF from .tex file in local style
#_#
.tex.pdf:
	@xelatex --shell-escape -interaction=batchmode "$<"

$(pdf_targets): Makefile *.sty

#_# TARGET.show
#_#   View TARGET.pdf in browser
#_#
# Attempting to preserve the current focus here fails. Why?
.pdf.show:
	@webrows start >/dev/null 2>&1 || true
	@webrows webrows get 'file://$(PWD)/$<'

#_# TARGET.view
#_#   Build TARGET.pdf from TARGET.tex and show in browser
#_#
# Attempting to preserve the current focus here fails. Why?
.tex.view:
	@$(MAKE) '$*.pdf'
	@$(MAKE) '$*.show'
	@printf '%s\n' '$<' $(listen_files) | entr -np webrows webrows refresh

