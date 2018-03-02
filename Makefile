HUGO  := hugo
THEME := tracer

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
