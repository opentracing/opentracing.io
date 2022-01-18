HUGO  := hugo
THEME := tracer
THEME_DIR := themes/$(THEME)
NETLIFY_URL = https://opentracing.io

.PHONY: build
build: setup
	$(HUGO) \
		--verbose \
		--theme $(THEME) \
		--baseURL $(NETLIFY_URL)

.PHONY: build-preview
build-preview: setup
	$(HUGO) \
		--theme $(THEME) \
		--baseURL $(DEPLOY_PRIME_URL)

.PHONY: clean
clean:
	rm -rf public/* resources

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
	git submodule update --init

.PHONY: setup
setup: clean get-spec-docs
