deploy:
    quarto render
    cp results/* _site/results/
    quarto publish gh-pages
