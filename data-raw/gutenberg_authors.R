# The dataset is prepared via GitHub actions. See
# .github/workflows/oxigraph.yaml for details. The "Extract authors" step
# outputs a "./gutenberg_authors.csv" file that is available during the GHA run.



usethis::use_data(gutenberg_authors, overwrite = TRUE, compress = "xz")
