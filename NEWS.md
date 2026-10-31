# OECDdata 0.3.4

## R-hub corrections

* Keep XML errors and warnings inside the native parser's own handler on
  libxml2 2.15.2. Remove parser flags that bypassed that handler and allowed an
  error handler installed by xml2 to interrupt parsing. Retain strict malformed
  XML rejection, cleanup, and the indexed C extraction engine.
* Extend malformed-input regressions to check recovery after errors, preservation
  of xml2's own warning handling, and warning isolation for text, raw and file input.
* Declare both knitr and rmarkdown as vignette builders, so checks with optional
  suggested packages omitted can still rebuild the R Markdown vignette.
* Use directory junctions for the Windows temporary-directory alias regression
  and explicitly verify alias removal without deleting its physical target.
  Preserve the canonical-parent checks for lazily created cache directories.
* Run the small test fixtures with one data.table thread and restore the prior
  thread setting afterward. This avoids OpenMP worker allocation in memory checks
  without changing threading behavior in normal package use.

# OECDdata 0.3.3

## XML memory ownership

* Keep native parser errors local to each libxml2 context, so another package's
  process-wide error handler cannot interrupt partial-document cleanup.
* Reclaim an unfinished parser document on an unexpected nonlocal exit,
  without resetting a document whose ownership has already transferred.
* Convert accepted xml2 objects through the public connection writer, avoiding
  a leaking serialization path in xml2 1.6.0 while retaining UTF-8 semantics.
* Protect newly allocated R strings across cleanup callbacks, resolving the
  native protection issue identified by rchk.
* Free permanently discarded test-fixture subtrees explicitly, so their
  allocations are reclaimed after removal from the owning XML document.
* Retain the indexed C XML extraction engine, Windows installation fixes, and
  symlink-safe CRAN regression tests from 0.3.1 and 0.3.2.

## Source installation

* Preserve spaces in custom Unix libxml2 include and library directories,
  matching the existing Windows flag quoting.

# OECDdata 0.3.2

## CRAN M1mac correction

* Fix the temporary-cache location assertion reported by CRAN's M1mac check.
  Compare the canonical existing parent directory instead of canonicalizing a
  cache directory that has not yet been created. This preserves lazy cache
  creation and works when the temporary directory has a symbolic-link alias.
* Report raw paths, existence status and canonical parents in path assertion
  failures. Check exact parent equality for cache and browser-preview files.
* Add a regression covering deferred cache creation through a directory symlink.
* Load the suggested test framework conditionally and limit data.table to at
  most two threads during package tests, restoring its previous setting.
* Clean up every CSV fixture created by the structure-type regression loop.
* Canonicalize maintainer report directories after creating them, and preserve
  case-sensitive path comparisons on Unix-alike systems.

## Distribution and performance

* Retain the native XML engine and Windows installation corrections from 0.3.1.
  Both the CRAN and full GitHub variants use the same runtime implementation.
* Build a lean CRAN archive and a full GitHub archive from the same source;
  verify that all runtime, native build, documentation and test files match.
  Keep optional benchmarks and historical validation evidence in the GitHub
  distribution, together with native binary release workflows.

# OECDdata 0.3.1

## Windows source installation

* Fix a false "libxml2 was not found" configuration failure when Rtools has
  the library but pkg-config is missing, unusable, or resolves unrelated
  libraries from PATH.
* Discover R's selected native library directory through R_TOOLS_SOFT and
  LOCAL_SOFT. Prefer its pkg-config and fall back to its libxml2 headers and
  static dependencies without downloading libraries.
* Validate every selected set of flags with an actual compile and link probe.
  Preserve paths containing spaces and discard stale generated flags on failure.
* Add configuration regressions and Windows source-install CI across current
  and older Rtools, including installations with pkg-config deliberately disabled.
* Keep the native XML processing implementation introduced in 0.3.0.

# OECDdata 0.3.0

## Performance

* Extract catalogue and codelist columns in C through libxml2, avoiding
  per-item R callbacks, repeated XPath evaluation, and one-row catalogue tables.
* Index dataflows, DSDs, codelists, concept schemes and content constraints once
  per document. Read production XML directly from downloaded files.
* Select catalogue versions without allocating one `.SD` table per group.
* Preserve the public import API, result classes and attributes, localization,
  dictionary identifiers, version resolution and raw-response cache semantics.

## Native build and validation

* Register native routines with dynamic symbol lookup disabled. Native XML
  documents have explicit ownership, child lifetime protection and unwind cleanup.
* Require a C compiler and libxml2 development files for source installation.
  Windows uses the matching Rtools static libraries.
* Add regression coverage for XML semantics, errors, document lifetimes, complete
  public imports and offline cache replay.
* Reject DTD declarations. Predefined and numeric entities, CDATA, mixed
  content, namespace prefixes and UTF-8 remain supported.
* Add an offline XML benchmark with a frozen 0.2.5 reference implementation,
  configurable inputs, parity checks, per-run timings and input hashes.
* Add GitHub Actions to build, reinstall, test and publish native binaries for
  Windows, Ubuntu 24.04 and macOS 15, each on x86_64 and ARM64.

## Compatibility repair

* Use `data.table::setattr()` for availability attributes in metadata tables.
  This preserves allocation/reference state when `describe()` removes and adds
  columns, including with data.table 1.14.10.

See `inst/PERFORMANCE.md` and `inst/VALIDATION.md` in the full GitHub
distribution for measured results and scope.
