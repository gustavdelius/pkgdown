build_redirects <- function(pkg = ".",
                            override = list()) {
  pkg <- section_init(pkg, depth = 1L, override = override)

  if (is.null(pkg$meta$redirects)) {
    return(invisible())
  }

  rule("Building redirects")
  if (is.null(pkg$meta$url)) {
    abort(sprintf("Can't find %s.", pkgdown_field(pkg, "url")))
  }

  # after the local search PR is merged the sitemap will be actually complete
  sitemap <- xml2::read_xml(file.path(pkg$dst_path, "sitemap.xml"))
  paths <- xml2::xml_contents(sitemap) %>%
    purrr::map_chr(xml2::xml_text) %>%
    purrr::map_chr(function(x) httr::parse_url(x)$path) %>%
    fs::path_ext_remove()

  purrr::walk2(
    names(pkg$meta$redirects),
    pkg$meta$redirects,
    build_redirect,
    pkg = pkg,
    paths = paths
  )
}

build_redirect <- function(new, old, pkg, paths) {
  # New page must exist
  if (!new %in% paths) {
    abort(
      sprintf(
        "Can't find the page %s from %s.",
        new,
        pkgdown_field(pkg, "redirects")
      )
    )
  }
  # Old pages must not exist
  if (any(old %in% paths)) {
    abort(
      sprintf(
        "Must redirect an non-existing page:\nPage(s) %s from %s exist(s) in the built site.",
        old[old %in% paths],
        pkgdown_field(pkg, "redirects")
      )
    )
  }

  # after the local search PR is merged hopefully the prefix will be in pkg
  pkg$prefix <- ""
  if (pkg$development$in_dev) {
    pkg$prefix <- paste0(
      meta_development(pkg$meta, pkg$version)$destination,
      "/"
    )
  }
  url <- sprintf("%s/%s%s.html/", pkg$meta$url, pkg$prefix, new)
  lines <- sprintf('
    <html>
      <head>
        <meta http-equiv="refresh" content="0;URL=%s" />
        <script language="javascript">
        window.location.href = "%s"
        </script>
      </head>
    </html>
  ',
    url, url
  )

  purrr::map(old, function(x) write_lines(lines, file.path(pkg$dst_path, paste0(x, ".html"))))

}
