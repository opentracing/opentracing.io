HUGO  := hugo
THEME := tracer

clean:
	rm -rf public

build: clean
	ENV=production $(HUGO) \
		--theme $(THEME)

serve: clean
	ENV=development	$(HUGO) serve \
		--theme $(THEME) \
		--buildFuture \
		--buildDrafts \
		--disableFastRender
