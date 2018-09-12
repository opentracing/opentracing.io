HUGO  := hugo
THEME := tracer
THEME_DIR := themes/$(THEME)
NETLIFY_URL = https://opentracing.netlify.com

.PHONY: build
build: setup
	$(HUGO) \
		--theme $(THEME) \
		--baseURL $(NETLIFY_URL)

.PHONY: build-preview
build-preview: setup
	$(HUGO) \
		--theme $(THEME) \
		--baseURL $(DEPLOY_PRIME_URL)

.PHONY: clean
clean:
	rm -rf public

.PHONY: serve
serve: clean
	$(HUGO) serve \
		--theme $(THEME) \
		--buildFuture \
		--buildDrafts \
		--disableFastRender \
		--ignoreCache

.PHONY: get-spec-docs
get-spec-docs:
	git submodule update

.PHONY: setup
setup: clean get-spec-docs