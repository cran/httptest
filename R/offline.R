#' Skip tests that need an internet connection if you don't have one
#'
#' Temporary connection trouble shouldn't fail your build.
#'
#' Note that if you call this from inside one of the mock contexts, it will
#' follow the mock's behavior. That is, inside [with_fake_http()],
#' the check will pass and the following tests will run, but inside
#' [without_internet()], the following tests will be skipped.
#' @param message character message to be printed, passed to
#' [testthat::skip()]
#' @param url character URL to ping to check for a working connection
#' @return If offline, a test skip; else invisibly returns TRUE.
#' @seealso [testthat::skip()]
#' @importFrom testthat skip skip_on_cran
#' @export
skip_if_disconnected <- function(message = paste("Offline: cannot reach", url),
                                 url = "http://httpbin.org/") {
  skip_on_cran()
  if (currently_offline(url)) {
    skip(message)
  }
  invisible(TRUE)
}

#' @importFrom httr GET PUT POST PATCH DELETE VERB RETRY
currently_offline <- function(url = "http://httpbin.org/") {
  inherits(try(httr::GET(url), silent = TRUE), "try-error")
}
