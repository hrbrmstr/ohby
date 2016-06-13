#' Create an "OhBy" code for some content
#'
#' What is "oh by"? "oh by" is a simple primitive that you can use to condense information.
#' It is, sort of, a combination of a pastebin-style site and a URL shortener.
#' The real utility are the easily recognizable codes, prefixed with "0x".
#'
#' @param content up to 4096 bytes of content, optionally a URL
#' @param expiration either "\code{never}" or a number followed by one of \code{m h D W M Y} for
#'        \emph{minute}, \emph{hour}, \emph{Day}, \emph{Week}, \emph{Month}, \emph{Year}.
#' @param visibility either "\code{public}" or "\code{private}". The \emph{public} codes are
#'        indexable by search engines
#' @param redirect if \code{content} is a URL, then set this to \code{TRUE} to have it behave like a URL
#'        shortenter.
#' @export
#' @examples
#' shorten("http://rud.is/b")
#' shorten("The quick, brown fox jumps over the lazy dog")
shorten <- function(content, expiration="never", visibility=c("public", "private"), redirect=FALSE) {

  redirect <- ifelse(redirect, 1, 0)
  visibility <- match.arg(visibility, c("public", "private"))
  visibility <- ifelse(visibility=="public", 1, 0)

  if (expiration == "never") {
    expiration = 0
  } else {
    expiration <- gsub("[[:space:]]", "", expiration)
    if (sum(is.na(unlist(stri_match_all_regex("10m", "([[:digit:]]+)([mhDWMY])")))) != 0) {
      stop("Expiration should either be 'never' or a digit + one of [mhDWMY]", call.=FALSE)
    }
  }

  res <- httr::POST("https://0x.co/shorten.html",
                    encode="form",
                    body=list(content=content,
                              expiry=expiration,
                              visibility=visibility,
                              redirect=redirect))
  stop_for_status(res)

  pg <- httr::content(res, as="parsed", encoding="UTF-8")

  code <- gsub("0 x ", "", html_text(html_nodes(pg, "strong > font")))
  URL <- html_attr(html_nodes(pg, "p > a[href^='htt']"), "href")
  sha256 <- gsub("SHA256 = ", "", html_text(html_nodes(pg, "font:contains('SHA')")))

  list(code=code, url=URL, sha256=sha256)

}

#' Expand an 'OhBy' URL
#'
#' @param ohby_url the URL to expand
#' @export
#' @examples
#' expand("https://0x.co/3BE87E")
#' expand("https://0x.co/6VZ69Z")
expand <- function(ohby_url) {

  if (!grepl("^http[s]://0x\\.co", ohby_url)) {
    stop("This doesn't look like an OhBy URL.", call.=FALSE)
  }

  res <- httr::GET(ohby_url)

  pg <- content(res, encoding="UTF-8")
  if (length(html_nodes(pg, "meta[http-equiv]")) == 0) {
    trimws(html_text(html_nodes(pg, "p + center + p + p")[[1]]))
  } else {
    gsub("1;URL=", "", html_attr(html_nodes(pg, "meta[http-equiv]"), "content"))
  }

}