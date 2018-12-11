default: dist
.PHONY: default

SRCS = $(wildcard ./lib/*.js)

node_modules: package.json
	npm install
	touch $@

dist: node_modules $(SRCS) etc/webpack/pubcontrol.webpack.js
	npm run make:dist
	touch $@
