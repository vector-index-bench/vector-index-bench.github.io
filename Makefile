.PHONY: preview deploy render copy-results

render:
	quarto render

copy-results:
	mkdir -p _site/results
	cp results/* _site/results/

preview: render copy-results
	quarto preview

deploy: render copy-results
	quarto publish gh-pages
