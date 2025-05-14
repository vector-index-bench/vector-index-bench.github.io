#!/usr/bin/env bash

set -e

quarto render
cp results/* _site/results/
quarto publish gh-pages
