#!/usr/bin/env Rscript

# The dataset is prepared via GitHub actions. See
# .github/workflows/oxigraph.yaml for details. The "Extract metadata" step
# outputs a "./gutenberg_metadata.csv" file that is available during the GHA
# run.

## Run once: Initialize gutenberg_metadata with a 0-row tibble. -----------------

# gutenberg_metadata <- tibble::tibble(
#   gutenberg_author_id = 1L,
#   author = "a",
#   birthdate = as.Date(NA_integer_),
#   deathdate = as.Date(NA_integer_),
#   .rows = 0
# )
# usethis::use_data(
#   gutenberg_metadata,
#   overwrite = TRUE,
#   compress = "xz",
#   version = 3
# )

# For regular updates, packages are kept to a minimum (thus steps like setting
# the class, rather than calling tibble::as_tibble()).

## Load updated dataset if it exists. ------------------------------------------
if (file.exists("gutenberg_metadata.csv")) {
  gutenberg_metadata_new <- read.csv(
    "gutenberg_metadata.csv",
    na.strings = c("NA", "null")
  )
  class(gutenberg_metadata_new) <- c("tbl_df", "tbl", "data.frame")
  load("./data/gutenberg_metadata.rda")
  attr(gutenberg_metadata, "date_updated") <- NULL
  if (!identical(gutenberg_metadata_new, gutenberg_metadata)) {
    ## Finish dataset and save -------------------------------------------------
    gutenberg_metadata <- gutenberg_metadata_new
    attr(gutenberg_metadata, "date_updated") <- Sys.Date()
    save(
      gutenberg_metadata,
      file = "./data/gutenberg_metadata.rda",
      compress = "xz",
      version = 3
    )
  }

  ## Clean up ------------------------------------------------------------------
  rm(list = intersect(ls(), c("gutenberg_metadata", "gutenberg_metadata_new")))
}
rm(csv_path)
