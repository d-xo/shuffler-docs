# Build the static site from the markdown source.
#   make        -> generate index.html from readme.md
#   make serve  -> build, then serve locally at http://localhost:8000
#   make clean  -> remove generated output

PANDOC ?= pandoc
SRC    := readme.md
OUT    := index.html
TITLE  := The Plan Based Shuffler

$(OUT): $(SRC) assets/template.html assets/style.css
	$(PANDOC) $(SRC) \
	  --from=gfm+tex_math_dollars \
	  --to=html5 \
	  --standalone \
	  --template=assets/template.html \
	  --mathjax \
	  --metadata pagetitle="$(TITLE)" \
	  --output=$(OUT)

.PHONY: serve clean
serve: $(OUT)
	@echo "serving on http://localhost:8000  (ctrl-c to stop)"
	@python3 -m http.server 8000

clean:
	rm -f $(OUT)
