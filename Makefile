HUGO  := hugo
THEME := tracer
THEME_DIR := themes/$(THEME)
NODE_BIN := node_modules/.bin
GULP := $(NODE_BIN)/gulp
FIREBASE_PROJECT := opentracing-website
FIREBASE_URL := https://$(FIREBASE_PROJECT).firebaseapp.com
FIREBASE := $(NODE_BIN)/firebase

clean:
	rm -rf public

build: clean build-assets
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
		--disableFastRender

build-assets:
	(cd $(THEME_DIR) && $(GULP) build)

develop-assets:
	(cd $(THEME_DIR) && $(GULP) dev)

setup:
	yarn
	npm rebuild node-sass
