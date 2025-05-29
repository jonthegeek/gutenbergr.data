#!/usr/bin/env Rscript

# The dataset is prepared via GitHub actions. See
# .github/workflows/oxigraph.yaml for details. The "Extract ebook authors" step
# outputs a "./gutenberg_ebook_authors.csv" file that is available during the
# GHA run.

## Run once: Initialize gutenberg_ebook_authors with a 0-row tibble. -----------------

# gutenberg_ebook_authors <- tibble::tibble(
#   gutenberg_id = 1L,
#   gutenberg_author_id = 1L,
#   .rows = 0
# )
# usethis::use_data(
#   gutenberg_ebook_authors,
#   overwrite = TRUE,
#   compress = "xz",
#   version = 3
# )

# For regular updates, packages are kept to a minimum (thus steps like setting
# the class, rather than calling tibble::as_tibble()).

## Load updated dataset if it exists. ------------------------------------------
csv_path <- "gutenberg_ebook_authors.csv"
if (file.exists(csv_path)) {
  gutenberg_ebook_authors_new <- read.csv(
    csv_path,
    na.strings = c("NA", "null")
  )
  class(gutenberg_ebook_authors_new) <- c("tbl_df", "tbl", "data.frame")
  load("./data/gutenberg_ebook_authors.rda")
  attr(gutenberg_ebook_authors, "date_updated") <- NULL
  if (!identical(gutenberg_ebook_authors_new, gutenberg_ebook_authors)) {
    ## Finish dataset and save -------------------------------------------------
    gutenberg_ebook_authors <- gutenberg_ebook_authors_new
    attr(gutenberg_ebook_authors, "date_updated") <- Sys.Date()
    save(
      gutenberg_ebook_authors,
      file = "./data/gutenberg_ebook_authors.rda",
      compress = "xz",
      version = 3
    )
  }

  ## Clean up ------------------------------------------------------------------
  rm(list = intersect(ls(), c("gutenberg_ebook_authors", "gutenberg_ebook_authors_new")))
  unlink(csv_path)
}
rm(csv_path)
