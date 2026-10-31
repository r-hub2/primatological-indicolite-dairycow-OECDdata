## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")
library(OECDdata)
library(data.table)
library(magrittr)
old <- oecdOptions(quiet = TRUE, open_browser = FALSE,
                   return_data_table = TRUE, strings_as_factors = FALSE)

## ----example------------------------------------------------------------------
x <- oecdExample()
x[, .(REF_AREA, TIME_PERIOD, value_, flags_)]

## ----structure----------------------------------------------------------------
attr(x, "Dimensions")
attr(x, "OECDAttributes")
str(x)

## ----audit--------------------------------------------------------------------
series_keys <- setdiff(attr(x, "Dimensions"), "TIME_PERIOD")
x[, .(observations = .N, missing = sum(is.na(value_))), by = series_keys]
x[, .N, by = OBS_STATUS]

## ----pivot--------------------------------------------------------------------
stopifnot(x[, uniqueN(FREQ)] == 1L, x[, uniqueN(MEASURE)] == 1L,
          x[, uniqueN(GROUP)] == 1L,
          !anyDuplicated(x, by = c("TIME_PERIOD", "REF_AREA")))
dcast(x, TIME_PERIOD ~ REF_AREA, value.var = "value_")

## ----plot, fig.width=6.5, fig.height=3.5--------------------------------------
one <- x[REF_AREA == "USA"][order(TIME_PERIOD)]
plot(as.Date(paste0(one$TIME_PERIOD, "-01")), one$value_, type = "l",
     xlab = "Month", ylab = "Synthetic index", main = "Invented example")

## ----growth-------------------------------------------------------------------
copy(x) %>%
  .[, month_id := as.integer(substr(TIME_PERIOD, 1, 4)) * 12L +
                  as.integer(substr(TIME_PERIOD, 6, 7))] %>%
  .[order(month_id), `:=`(previous = shift(value_),
                        previous_month = shift(month_id)), by = series_keys] %>%
  .[, growth_pct := fifelse(!is.na(previous) & previous != 0 &
                             month_id - previous_month == 1L,
                           100 * (value_ / previous - 1), NA_real_)] %>%
  .[, .(REF_AREA, TIME_PERIOD, growth_pct)]

## ----discovery, eval=FALSE----------------------------------------------------
#  OECDdata::find("health expenditure")
#  OECDdata::find(education, expenditure)
#  browseDataList(grepl("employment", `Dataset name`, ignore.case = TRUE))
#  
#  code <- "CLI"
#  s <- oecdStructure(code)
#  s$flow
#  s$dimensions
#  s$labels$REF_AREA
#  importLabels("REF_AREA", dataset = code)
#  describe(code, wide = TRUE)

## ----resolve, eval=FALSE------------------------------------------------------
#  ref <- oecdDataset("CLI", agency = "OECD.SDD.STES", prefix = "DSD_STES")
#  ref
#  importLabels(OECDDimCode = "REF_AREA", dataset = ref)
#  
#  # A query preview fetches metadata but does not download observations.
#  oecdQuery("CLI", filters = list(
#    .dataset = list(agency = "OECD.SDD.STES", prefix = "DSD_STES"),
#    REF_AREA = "USA", FREQ = "M", TIME_PERIOD = c("2023-01", "2023-12")
#  ))

## ----live, eval=FALSE---------------------------------------------------------
#  cli <- importData(code, list(REF_AREA = c("USA", "FRA"), FREQ = "M",
#                               TIME_PERIOD = c("2023-01", "2023-12")))
#  attr(cli, "SourceURL")
#  attr(cli, "OECDDatasetCode")

## ----provenance---------------------------------------------------------------
attributes(x)[c("RequestedDatasetCode", "OECDDatasetCode", "DownloadTime",
                "SourceURL", "Dimensions")]

## ----persistent, eval=FALSE---------------------------------------------------
#  oecdOptions(cache_dir = tools::R_user_dir("OECDdata", "cache"))
#  # First make a successful online request with the desired metadata and filters.
#  # Then use offline = TRUE with the same request.
#  saveRDS(list(data = cli, provenance = attributes(cli)), "cli-snapshot.rds")

## ----restore, include=FALSE---------------------------------------------------
options(old)

