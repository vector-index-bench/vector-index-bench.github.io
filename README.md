# VIBE: Vector Index Benchmark for Embeddings Website

This repository hosts the code for the interactive website reporting the results of the [VIBE benchmark](https://github.com/vector-index-bench/vibe).

## Software requirements

To build and deploy the website you need a recent version of [quarto](https://quarto.org/).

If you have [Nix](https://nixos.org/) with flakes enabled, `flake.nix` provides a
shell with a working Quarto, so you can skip installing anything else:

```bash
nix develop
```

> The flake exists because Quarto is picky about its Pandoc version, and the one
> `nixpkgs` pairs it with is too old: every render fails with
> `Aeson exception: Error in $: Unknown option "syntax-highlighting"`. The flake
> overrides Quarto's Pandoc with the release binary it expects.

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
