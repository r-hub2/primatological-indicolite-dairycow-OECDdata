test_that("native parse errors stay local when xml2 has installed error handlers", {
  invisible(xml2::read_xml("<root/>"))
  xml2_warnings <- function() {
    messages <- character()
    withCallingHandlers(
      invisible(xml2::read_xml('<root xmlns="relative"/>')),
      warning = function(w) {
        messages <<- c(messages, conditionMessage(w))
        invokeRestart("muffleWarning")
      }
    )
    messages
  }
  warnings_before <- xml2_warnings()
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

  # An error must not leave the parser or the other package's handlers broken.
  expect_identical(OECDdata:::.attr(
    OECDdata:::.read_xml('<root id="intact"/>', FALSE), "id"), "intact")
  expect_identical(xml2_warnings(), warnings_before)
  expect_identical(xml2::xml_name(xml2::read_xml("<root/>")), "root")
})

test_that("native parser warnings do not escape through xml2 handlers", {
  invisible(xml2::read_xml("<root/>"))
  # A relative namespace URI raises a libxml2 warning on affected versions.
  input <- '<root xmlns="relative"/>'
  path <- tempfile(fileext = ".xml")
  on.exit(unlink(path), add = TRUE)
  writeBin(charToRaw(input), path)
  expect_silent(OECDdata:::.read_xml(input, FALSE))
  expect_silent(OECDdata:::.read_xml(charToRaw(input), FALSE))
  expect_silent(OECDdata:::.read_xml(path))
})
