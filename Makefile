HUGO  := hugo
THEME := tracer
THEME_DIR := themes/$(THEME)
NODE_BIN := node_modules/.bin
GULP := $(NODE_BIN)/gulp
CONCURRENTLY := $(NODE_BIN)/concurrently
NETLIFY_URL = https://opentracing.netlify.com

clean:
	rm -rf public

build: clean build-assets
	$(HUGO) \
		--theme $(THEME)

netlify-setup: setup
	(cd $(THEME_DIR) && npm install)

netlify-build: netlify-setup clean build-assets
	$(HUGO) \
		--theme $(THEME) \
		--baseURL $(NETLIFY_URL)

netlify-build-preview: netlify-setup clean build-assets
	$(HUGO) \
		--theme $(THEME) \
		--baseURL $(DEPLOY_PRIME_URL)

serve: clean
	$(HUGO) serve \
		--theme $(THEME) \
		--buildFuture \
		--buildDrafts \
		--disableFastRender \
		--ignoreCache

build-assets:
	(cd $(THEME_DIR) && $(GULP) build)

develop-assets:
	(cd $(THEME_DIR) && $(GULP) dev)

dev:
	$(CONCURRENTLY) "make serve" "make develop-assets"

get-spec-docs:
	git submodule update --recursive --remote

setup: get-spec-docs
	npm install
