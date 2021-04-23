test_that("build_redirect() works", {
  pkg <- list(
    dst_path = withr::local_tempdir(),
    meta = list(url = "https://example.com"),
    development = list(in_dev = FALSE)
  )
  build_redirect("new", c("old", "old2"), pkg = pkg, paths = "new")
  expect_snapshot(
    cat(read_lines(file.path(pkg$dst_path, "old.html")))
  )
  expect_true(file.exists(file.path(pkg$dst_path, "old2.html")))

})

test_that("build_redirect() errors when wrong paths", {
  expect_snapshot_error(
    build_redirect("bla", "blop", pkg = list(), paths = "nada")
  )
  expect_snapshot_error(
    build_redirect("nada", "nada", pkg = list(), paths = "nada")
  )
})
