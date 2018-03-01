HUGO  := hugo
THEME := tracer

build:
	ENV=production $(HUGO) \
		--theme $(THEME)

serve:
	ENV=development	$(HUGO) serve \
		--theme $(THEME) \
		--buildFuture \
		--buildDrafts \
		--disableFastRender
