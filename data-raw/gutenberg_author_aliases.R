#!/usr/bin/env Rscript

# The dataset is prepared via GitHub actions. See
# .github/workflows/oxigraph.yaml for details. The "Extract author aliases" step
# outputs a "./gutenberg_author_aliases.csv" file that is available during the
# GHA run.

## Run once: Initialize gutenberg_author_aliases with a 0-row tibble. -----------------

# gutenberg_author_aliases <- tibble::tibble(
#   gutenberg_author_id = 1L,
#   alias = "a",
#   .rows = 0
# )
# usethis::use_data(
#   gutenberg_author_aliases,
#   overwrite = TRUE,
#   compress = "xz",
#   version = 3
# )

# For regular updates, packages are kept to a minimum (thus steps like setting
# the class, rather than calling tibble::as_tibble()).

## Load updated dataset if it exists. ------------------------------------------
csv_path <- "gutenberg_author_aliases.csv"
if (file.exists(csv_path)) {
  gutenberg_author_aliases_new <- read.csv(
    csv_path,
    na.strings = c("NA", "null")
  )
  class(gutenberg_author_aliases_new) <- c("tbl_df", "tbl", "data.frame")
  load("./data/gutenberg_author_aliases.rda")
  attr(gutenberg_author_aliases, "date_updated") <- NULL
  if (!identical(gutenberg_author_aliases_new, gutenberg_author_aliases)) {
    ## Finish dataset and save -------------------------------------------------
    gutenberg_author_aliases <- gutenberg_author_aliases_new
    attr(gutenberg_author_aliases, "date_updated") <- Sys.Date()
    save(
      gutenberg_author_aliases,
      file = "./data/gutenberg_author_aliases.rda",
      compress = "xz",
      version = 3
    )
  }

  ## Clean up ------------------------------------------------------------------
  rm(list = intersect(ls(), c("gutenberg_author_aliases", "gutenberg_author_aliases_new")))
  unlink(csv_path)
}
rm(csv_path)
