HUGO  := hugo
THEME := tracer
THEME_DIR := themes/$(THEME)
NODE_BIN := node_modules/.bin
GULP := $(NODE_BIN)/gulp
CONCURRENTLY := $(NODE_BIN)/concurrently
FIREBASE_PROJECT := opentracing-website
FIREBASE_URL := https://$(FIREBASE_PROJECT).firebaseapp.com
FIREBASE := $(NODE_BIN)/firebase
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
		--theme $(THEME)

deploy: clean build-assets
	$(HUGO) \
		--theme $(THEME) \
		--baseURL $(FIREBASE_URL)
	$(FIREBASE) deploy \
		--only hosting \
		--token $(FIREBASE_TOKEN) \
		--project $(FIREBASE_PROJECT)


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

setup:
	yarn
	git submodule update --recursive --remote
