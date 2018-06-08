HUGO  := hugo
THEME := tracer
THEME_DIR := themes/$(THEME)
NODE_BIN := node_modules/.bin
GULP := $(NODE_BIN)/gulp
CONCURRENTLY := $(NODE_BIN)/concurrently
NPM := $(shell bash -l -c "nvm use 2>&1 > /dev/null && which npm")
NETLIFY_URL = https://opentracing.netlify.com

.PHONY: build
build: setup build-assets netlify-build
	$(HUGO) \
		--theme $(THEME)

.PHONY: clean
clean:
	rm -rf public

.PHONY: distclean
distclean: clean
	rm -rf node_modules
	rm -rf themes/tracer/node_modules

.PHONY: serve
serve: clean
	$(HUGO) serve \
		--theme $(THEME) \
		--buildFuture \
		--buildDrafts \
		--disableFastRender \
		--ignoreCache

.PHONY: build-assets
build-assets:
	(cd $(THEME_DIR) && $(GULP) build)

.PHONY: develop-assets
develop-assets:
	(cd $(THEME_DIR) && $(GULP) dev)

.PHONY: dev
dev:
	$(CONCURRENTLY) "make serve" "make develop-assets"

.PHONY: get-spec-docs
get-spec-docs:
	git submodule update --init --recursive --remote

.PHONY: setup
setup: get-spec-docs netlify-setup
	$(NPM_INSTALL)

.PHONY: netlify-setup
netlify-setup:
	(cd $(THEME_DIR) && $(NPM) install)

.PHONY: netlify-build
netlify-build: netlify-setup clean build-assets
	$(HUGO) \
		--theme $(THEME) \
		--baseURL $(NETLIFY_URL)

.PHONY: netlify-build-preview
netlify-build-preview: netlify-setup clean build-assets
	$(HUGO) \
		--theme $(THEME) \
		--baseURL $(DEPLOY_PRIME_URL)
