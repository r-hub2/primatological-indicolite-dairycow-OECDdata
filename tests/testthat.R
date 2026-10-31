if (requireNamespace("testthat", quietly = TRUE)) {
  library(testthat)
  library(OECDdata)
  (function() {
    # Keep checks within CRAN's two-core allowance, including on large hosts.
    previous_threads <- data.table::setDTthreads(min(2L, data.table::getDTthreads()))
    on.exit(data.table::setDTthreads(previous_threads), add = TRUE)
    test_check("OECDdata")
  })()
}
