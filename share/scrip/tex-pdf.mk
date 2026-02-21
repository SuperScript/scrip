#_# TARGET.pdf
#_#   Make PDF from .tex file in local style
#_#
.tex.pdf: Makefile $< *.sty
	xelatex --shell-escape -interaction=batchmode "$<"

#_# TARGET.show
#_#   View TARGET.pdf in browser
#_#
# Attempting to preserve the current focus here fails. Why?
.pdf.show: Makefile $<
	firefox --class '$@' --url '$*.pdf'

#_# TARGET.view
#_#   Build TARGET.pdf from TARGET.tex and show in browser
#_#
# Attempting to preserve the current focus here fails. Why?
.tex.view: Makefile $*.pdf
	$(MAKE) '$*.show' >/dev/null 2>&1 &
	echo '$<' | entr -np $(MAKE) '$*.update' >/dev/null 2>&1 &

#_# TARGET.update
#_#   Rebuild TARGET.pdf from TARGET.tex and refresh in browser
#_#
.tex.update: Makefile
	$(MAKE) '$*.pdf'
	xdotool search --class '$*.show' | while read w; do xdotool key --window "$$w" F5; done

#_# TARGET.quit
#_#   Quit viewing of TARGET.pdf in browser
#_#
.tex.quit: Makefile
	@xdotool search --class '$*.show' | while read w; do xdotool windowclose "$$w"; done
	@fstat '$*.tex' | awk '$$2=="entr"{print$$3}' | while read p; do kill -TERM "$$p"; done

