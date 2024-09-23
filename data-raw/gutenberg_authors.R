#!/usr/bin/env Rscript

# The dataset is prepared via GitHub actions. See
# .github/workflows/oxigraph.yaml for details. The "Extract authors" step
# outputs a "./gutenberg_authors.csv" file that is available during the GHA run.

## Run once: Initialize gutenberg_authors with a 0-row tibble. -----------------

# gutenberg_authors <- tibble::tibble(
#   gutenberg_author_id = 1L,
#   author = "a",
#   birthdate = as.Date(NA_integer_),
#   deathdate = as.Date(NA_integer_),
#   .rows = 0
# )
# usethis::use_data(
#   gutenberg_authors,
#   overwrite = TRUE,
#   compress = "xz",
#   version = 3
# )

# For regular updates, packages are kept to a minimum (thus steps like setting
# the class, rather than calling tibble::as_tibble()).

## Load updated dataset if it exists. ------------------------------------------
if (file.exists("gutenberg_authors.csv")) {
  gutenberg_authors_new <- read.csv("gutenberg_authors.csv")
  class(gutenberg_authors_new) <- c("tbl_df", "tbl", "data.frame")
  load("./data/gutenberg_authors.rda")
  attr(gutenberg_authors, "date_updated") <- NULL
  if (!identical(gutenberg_authors_new, gutenberg_authors)) {
    ## Finish dataset and save -------------------------------------------------
    gutenberg_authors <- gutenberg_authors_new
    attr(gutenberg_authors, "date_updated") <- Sys.Date()
    save(
      gutenberg_authors,
      file = "./data/gutenberg_authors.rda",
      compress = "xz",
      version = 3
    )
  }

  ## Clean up ------------------------------------------------------------------
  rm(list = intersect(ls(), c("gutenberg_authors", "gutenberg_authors_new")))
}
