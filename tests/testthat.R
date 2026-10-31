if (requireNamespace("testthat", quietly = TRUE)) {
  library(testthat)
  library(OECDdata)
  (function() {
    # These small fixtures need no OpenMP workers. Single-thread tests also
    # avoid attributing retained libgomp worker TLS to package leaks in Valgrind.
    previous_threads <- data.table::setDTthreads(1L)
    on.exit(data.table::setDTthreads(previous_threads), add = TRUE)
    test_check("OECDdata")
  })()
}
