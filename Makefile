.PHONY: run
run:
	@yqq w -i config.yaml params.search_api_key --tag '!!str' $(GOOGLE_CUSTOM_SEARCH_API_KEY)
	hugo server --config=config.yaml --buildDrafts --buildFuture

.PHONY: docs
docs:
	hugo-tools docs-aggregator
	find ./data -name "*.json" -exec sed -i 's/https:\/\/cdn.appscode.com\/images/\/assets\/images/g' {} \;

.PHONY: gen
gen-draft:
	rm -rf public
	@yqq w -i config.yaml params.search_api_key --tag '!!str' $(GOOGLE_CUSTOM_SEARCH_API_KEY)
	hugo --config=config.yaml --buildDrafts --buildFuture
	@yqq w -i config.yaml params.search_api_key --tag '!!str' '_replace_'

.PHONY: qa
qa: gen-draft
	firebase use default
	firebase deploy

.PHONY: gen-prod
gen-prod:
	rm -rf public
	@yqq w -i config.yaml params.search_api_key --tag '!!str' $(GOOGLE_CUSTOM_SEARCH_API_KEY)
	hugo --minify --config=config.yaml
	@yqq w -i config.yaml params.search_api_key --tag '!!str' '_replace_'

.PHONY: release
release:
	firebase use prod
	firebase deploy
	firebase use default
