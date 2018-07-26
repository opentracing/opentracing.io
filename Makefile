HUGO  := hugo
THEME := tracer
THEME_DIR := themes/$(THEME)
NPM := npm
NETLIFY_URL = https://opentracing.netlify.com

.PHONY: build
build: setup netlify-build
	$(HUGO) \
		--theme $(THEME)

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
	git submodule update --init --recursive --remote

.PHONY: setup
setup: get-spec-docs netlify-setup
	$(NPM) install

.PHONY: netlify-setup
netlify-setup:
	(cd $(THEME_DIR) && $(NPM) install)

.PHONY: netlify-build
netlify-build: netlify-setup clean
	$(HUGO) \
		--theme $(THEME) \
		--baseURL $(NETLIFY_URL)

.PHONY: netlify-build-preview
netlify-build-preview: netlify-setup clean
	$(HUGO) \
		--theme $(THEME) \
		--baseURL $(DEPLOY_PRIME_URL)
