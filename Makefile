# Build the static site from the markdown source.
#   make        -> generate index.html from readme.md
#   make serve  -> serve at http://localhost:$(PORT) with live reload
#   make clean  -> remove generated output

PANDOC ?= pandoc
SRC    := readme.md
OUT    := index.html
TITLE  := The Plan Based Shuffler
PORT   ?= 8080

# Sources that require a pandoc rebuild when they change (entr watches these).
WATCH  := readme.md assets/template.html assets/strip-title.lua

$(OUT): $(SRC) assets/template.html assets/style.css assets/strip-title.lua
	$(PANDOC) $(SRC) \
	  --from=gfm+tex_math_dollars \
	  --to=html5 \
	  --standalone \
	  --template=assets/template.html \
	  --lua-filter=assets/strip-title.lua \
	  --toc --toc-depth=3 \
	  --mathjax \
	  --metadata title="$(TITLE)" \
	  --metadata pagetitle="$(TITLE)" \
	  --output=$(OUT)

.PHONY: serve clean
# Live reload: entr rebuilds index.html when a source changes; live-server
# serves the tree and refreshes the browser on any change it observes
# (index.html after a rebuild, plus direct edits to viz/* and assets/*).
# Ctrl-c stops both.
serve: $(OUT)
	@echo "dev server: http://localhost:$(PORT)  (ctrl-c to stop)"
	@bash -c '\
	  printf "%s\n" $(WATCH) | entr -n -s "$(MAKE) --no-print-directory" & \
	  watcher=$$!; \
	  trap "kill $$watcher 2>/dev/null" EXIT INT TERM; \
	  live-server --port $(PORT) .'

clean:
	rm -f $(OUT)
