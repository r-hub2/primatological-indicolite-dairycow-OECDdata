# OECDdata

Fast access to OECD statistics through the public SDMX REST API.

The package discovers datasets, resolves dataset identifiers, imports filtered
observations and describes their dimensions and attributes. XML metadata are
indexed and extracted by the package's C extension using libxml2. Observation
CSV files are parsed with data.table. Both CRAN and GitHub distributions retain
the same native engine, public functions and runtime behavior.

## Installation

The package requires R 4.1.0 or newer. Install the published release with:

```r
install.packages("OECDdata")
```

To install a local source archive:

```r
install.packages("OECDdata_0.3.4.tar.gz", repos = NULL, type = "source")
```

Source installation requires a C compiler and libxml2 development files
(version 2.9.0 or newer). Windows uses the Rtools distribution matching R;
Rtools40 additionally needs its optional libxml2 package. On Debian or Ubuntu,
install `r-base-dev`, `libxml2-dev` and `pkg-config`. Custom native library
locations can be supplied through `LIBXML_CFLAGS` and `LIBXML_LIBS`.

## Offline example

```r
library(OECDdata)
head(oecdExample())
```

This uses synthetic bundled observations and makes no network request.
See `help(package = "OECDdata")` and the getting-started vignette for the
catalogue, filtering, labels, metadata and caching interfaces. Examples and
standard package tests do not require live OECD services.

## License and acknowledgments

MIT license. Author and maintainer: Alek Rutkowski
<alek.rutkowski@gmail.com>.

Runtime dependencies are data.table, curl, digest, magrittr, xml2, R's utils,
and the native libxml2 library. They retain their own authors and licenses.
The interface is inspired by eurodata; no GPL implementation is copied or
bundled. Installed `ATTRIBUTION.md` and `SOURCES.md` record dependency credits
and protocol references. Bundled data are synthetic, not OECD statistics.

Repository: https://github.com/alekrutkowski/OECDdata
