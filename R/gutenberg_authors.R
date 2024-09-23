#' Metadata about Project Gutenberg authors
#'
#' Data frame with metadata about each author of a Project Gutenberg work.
#'
#' @details To find the date on which this metadata was last updated, see
#'   `attr(gutenberg_authors, "date_updated")`.
#'
#' @format A tbl_df (see [tibble::tibble()]) with one row for each author, with
#'   the columns
#' \describe{
#'   \item{gutenberg_author_id}{Unique identifier for the author that can be
#'   used to join with the `gutenberg_metadata` dataset (coming soon to this
#'   package)}
#'   \item{author}{The `agent_name` field from the original metadata}
#'   \item{birthdate}{Year of birth}
#'   \item{deathdate}{Year of death}
#' }
#'
#' @examples
#'
#' # date last updated
#' attr(gutenberg_authors, "date_updated")
"gutenberg_authors"
