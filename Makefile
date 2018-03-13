HUGO  := hugo
THEME := tracer
THEME_DIR := themes/$(THEME)
NODE_BIN := node_modules/.bin
GULP := $(NODE_BIN)/gulp

clean:
	rm -rf public

build: clean
	$(HUGO) \
		--theme $(THEME)

serve: clean
	$(HUGO) serve \
		--theme $(THEME) \
		--buildFuture \
		--buildDrafts \
		--disableFastRender

develop-assets:
	(cd $(THEME_DIR) && $(GULP) dev)

setup:
	yarn
	npm rebuild node-sass
