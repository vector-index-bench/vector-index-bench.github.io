# VIBE: Vector Index Benchmark for Embeddings Website

This repository hosts the code for the interactive website reporting the results of the [VIBE benchmark](https://github.com/vector-index-bench/vibe).

## Software requirements

To build and deploy the website you need a recent version of [quarto](https://quarto.org/).

## Viewing the website locally

To view updated benchmark results, add (or update) the `parquet` files produced by the [`export_results.py`](https://github.com/vector-index-bench/vibe/blob/main/export_results.py) script in the main repository.
Add any new algorithms and datasets to `algorithms_basics.csv` and `dataset_basics.csv`, respectively.

From the repository root, start Quarto's preview server:

```bash
make preview
```

## Updating the results

After updating the result files, deploy the website with:

```bash
make deploy
```
