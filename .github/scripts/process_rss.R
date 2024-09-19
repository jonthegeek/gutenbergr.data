#!/usr/bin/env Rscript

url <- "https://www.gutenberg.org/cache/epub/feeds/today.rss"
rss <- xml2::read_xml(url)
pubDate <- xml2::xml_find_first(rss, ".//pubDate") |>
  xml2::xml_text() |>
  as.Date("%a, %d %b %Y %H:%M:%S %z")
items <- xml2::xml_find_all(rss, ".//item")
updates <- tibble::tibble(
  date = pubDate,
  id = items |>
    xml2::xml_find_first(".//link") |>
    xml2::xml_text() |>
    stringr::str_extract("\\d+$") |>
    as.integer(),
  language = items |>
    xml2::xml_find_first(".//description") |>
    xml2::xml_text() |>
    stringr::str_remove("^Language: ") |>
    tolower()
)

readr::read_csv("./data-raw/rss-updates.csv", col_types = "Dic") |>
  dplyr::bind_rows(updates) |>
  dplyr::arrange(date, id, language) |>
  dplyr::distinct(id, language, .keep_all = TRUE) |>
  readr::write_csv("./data-raw/rss-updates.csv")
