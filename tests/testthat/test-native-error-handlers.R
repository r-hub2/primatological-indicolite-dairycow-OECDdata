test_that("native parse errors stay local when xml2 has installed error handlers", {
  invisible(xml2::read_xml("<root/>"))
  inputs <- c("", "<root>", "<root><x></root>", "<root>&unknown;</root>",
              '<root a="1" a="2"/>')
  path <- tempfile(fileext = ".xml")
  on.exit(unlink(path), add = TRUE)
  invisible(lapply(inputs, function(input) {
    expect_error(OECDdata:::.read_xml(input, FALSE), "^Invalid XML:")
    expect_error(OECDdata:::.read_xml(charToRaw(input), FALSE), "^Invalid XML:")
    writeBin(charToRaw(input), path)
    expect_error(OECDdata:::.read_xml(path), "^Invalid XML:")
  }))
})
