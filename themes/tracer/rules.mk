NETLIFY_URL = https://opentracing.netlify.com

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
