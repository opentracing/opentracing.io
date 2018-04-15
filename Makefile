HUGO  := hugo
THEME := tracer
THEME_DIR := themes/$(THEME)
NODE_BIN := node_modules/.bin
GULP := $(NODE_BIN)/gulp
CONCURRENTLY := $(NODE_BIN)/concurrently
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
	git submodule update
	git submodule update --recursive --remote
	cp specification/{project_organization,rfc_process,rfc_template,semantic_conventions,specification}.md content/specification
	mv content/specification/project_organization.md content/specification/project-organization.md
	mv content/specification/rfc_process.md content/specification/rfc-process.md
	mv content/specification/rfc_template.md content/specification/rfc-template.md
	mv content/specification/semantic_conventions.md content/specification/semantic-conventions.md
