# VIBE: Vector Index Benchmark for Embeddings Website

This repository hosts the code for the interactive website reporting the results of the VIBE benchmark.

## Updating the results

To update the website with new results, just
add (or update) the `parquet` files produced by the [`export_results.py`](https://github.com/vector-index-bench/vibe/blob/main/export_results.py)
script in the main repository.

Then, to deploy the updated website, just run the command

    just deploy

If you don't want to install the [`just`](https://just.systems/) task runner, simply run the commands you can find in the `Justfile` one after the other.

## Software requirements

To build and deploy the website you need a recent version of [quarto](https://quarto.org/).
