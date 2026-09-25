# Salam CSV Audit

A small command-line data-quality tool built with the [Salam Programming Language](https://github.com/SalamLang/Salam). It checks a CSV export for missing or repeated column names, inconsistent row widths, missing cells, and repeated first-column record IDs. IDs are compared after trimming surrounding whitespace. When a column named `amount` exists, it also validates decimal values and reports their total, minimum, maximum, average, and negative/zero/positive counts. Bad amount cells are excluded from the statistics.

The three Salam source files have separate jobs: `src/audit.salam` examines record integrity, `src/amounts.salam` validates and aggregates amounts, and `src/main.salam` handles file input, output, and exit status.

## Run

Install [Salam v0.4.4](https://github.com/SalamLang/Salam/releases/tag/v0.4.4), then from this repository's root:

```sh
salam build src/main.salam --output=csv-audit
./csv-audit
CSV_AUDIT_FILE=examples/issues.csv ./csv-audit
```

The default input is `examples/expenses.csv`. Set `CSV_AUDIT_FILE` to any other CSV file. The first line is treated as a header. The first column is the unique ID, and an `amount` column is optional. Exit status is `0` for clean data, `2` for data-quality findings, and `1` when the input cannot be read.

Run `sh tests/smoke.sh` to check both clean and flawed examples.

## Docker

The Dockerfile uses the official [`basemax/salam:0.4.4`](https://hub.docker.com/r/basemax/salam/tags) image and compiles this CLI inside the image:

```sh
docker build -t salam-csv-audit .
docker run --rm salam-csv-audit
docker run --rm -v "$PWD/examples:/data:ro" -e CSV_AUDIT_FILE=/data/issues.csv salam-csv-audit
```

The container runs as the unprivileged user provided by the Salam image. On a machine without Docker, use the native `salam build` commands above.

## Example

```text
CSV audit:  examples/expenses.csv
Columns:  4
Records:  3
Malformed rows:  0
Missing required cells:  0
Duplicate IDs:  0
Valid amounts:  3
Invalid amounts:  0
Total amount:  28.75
Minimum amount:  3.25
Maximum amount:  18.5
Average amount:  9.583333333333334
```

This is a line-oriented CSV audit. Quoted fields containing embedded newlines are outside its scope. Repeated header names are reported as an error; if `amount` appears more than once, the first matching column is used for the displayed statistics.
