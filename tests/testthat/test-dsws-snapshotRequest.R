##############################################################################################

context("classConstructor.R : test of snapshotRequest method")

##############################################################################################

test_that("test of simple snapshot request for price datatype with relative dates", {
  if (Sys.getenv("DatastreamUsername") == "") {
    skip("Username not available")
  }
  skip_on_cran()



  mydsws <- dsws$new()

  myData <- mydsws$snapshotRequest(instrument = c("ABF","RIO","WPP"),
                                   datatype = "P",
                                   requestDate = "0D")

  expect_is(myData, "data.frame")
  expect_is(myData[1,2], "numeric")
  expect_equal(nrow(myData), 3)
  expect_equal(ncol(myData), 2)

})


##############################################################################################

test_that("test of simple snapshot request for price datatype with absolute dates", {
  if (Sys.getenv("DatastreamUsername") == "") {
    skip("Username not available")
  }
  skip_on_cran()

  mydsws <- dsws$new()

  myData <- mydsws$snapshotRequest(instrument = c("ABF","RIO","WPP"),
                                   datatype = "P",
                                   requestDate = as.Date("2015-12-09"))

  expect_is(myData, "data.frame")
  expect_is(myData[1,2], "numeric")
  expect_equal(nrow(myData), 3)
  expect_equal(ncol(myData), 2)

})


##############################################################################################

test_that("test of simple snapshot request with single datatypes that return strings", {
  if (Sys.getenv("DatastreamUsername") == "") {
    skip("Username not available")
  }
  skip_on_cran()

  mydsws <- dsws$new()

  myData <- mydsws$snapshotRequest(instrument = c("ABF","RIO","WPP"),
                                   datatype = "NAME",
                                   requestDate = "0D")

  expect_is(myData, "data.frame")
  expect_is(myData[1,2], "character")
  expect_equal(nrow(myData), 3)
  expect_equal(ncol(myData), 2)


})

##############################################################################################

test_that("test of simple snapshot request with datatypes that return dates", {
  if (Sys.getenv("DatastreamUsername") == "") {
    skip("Username not available")
  }
  skip_on_cran()

  mydsws <- dsws$new()

  myData <- mydsws$snapshotRequest(instrument = c("ABF","RIO","WPP"),
                                   datatype = "EPSFD",
                                   requestDate = "0D")

  expect_is(myData, "data.frame")
  expect_is(myData[1,2], "Date")
  expect_equal(nrow(myData), 3)
  expect_equal(ncol(myData), 2)


})

##############################################################################################

test_that("test of simple snapshot request with two datatypes that return name and dates", {
  if (Sys.getenv("DatastreamUsername") == "") {
    skip("Username not available")
  }
  skip_on_cran()

  mydsws <- dsws$new()

  myData <- mydsws$snapshotRequest(instrument = c("ABF","RIO","WPP"),
                                   datatype = c("NAME", "EPSFD"),
                                   requestDate = "0D")

  expect_is(myData, "data.frame")
  expect_is(myData[1,3], "Date")
  expect_equal(myData[1,2], "ASSOCIATED BRIT.FOODS")

  expect_equal(nrow(myData), 3)
  expect_equal(ncol(myData), 3)

})


##############################################################################################

test_that("test of chunked snapshot request with two datatypes that return name and dates", {
  if (Sys.getenv("DatastreamUsername") == "") {
    skip("Username not available")
  }
  skip_on_cran()

  mydsws <- dsws$new()

  symbolList <- mydsws$listRequest(instrument = "LFTSE100",
                                   datatype = "MNEM",
                                   requestDate = "0D")


  myData <- mydsws$snapshotRequest(instrument = symbolList[,2],
                                   datatype = c("NAME", "EPSFD"),
                                   requestDate = "0D")

  # Get the same data with chunking
  mydsws <- dsws$new()
  mydsws$chunkLimit <- 25L
  myDataChunked <- mydsws$snapshotRequest(instrument = symbolList[,2],
                                          datatype = c("NAME", "EPSFD"),
                                          requestDate = "0D")

  expect_identical(myData, myDataChunked)
})


##############################################################################################

test_that("test of equity risk premium", {
  if (Sys.getenv("DatastreamUsername") == "") {
    skip("Username not available")
  }
  skip_on_cran()

  mydsws <- dsws$new()

  myData <- mydsws$snapshotRequest(instrument = c("USASERP", "UKASERP", "EKASERP", "JPASERP", "WDASERP"),
                                   expression = "XXXX",
                                   requestDate =  as.Date("2016-01-15"))

  expect_is(myData, "data.frame")
  expect_is(myData[1,2], "numeric")
  expect_equal(nrow(myData), 5)
  expect_equal(ncol(myData), 2)
  expect_false(is.na(myData[1,2]))

})

##############################################################################################

test_that("test of requesting complex expression", {
# Actually this request gets a $$"ER","E21B","INVALID CODE..." error from Datastream
    if (Sys.getenv("DatastreamUsername") == "") {
    skip("Username not available")
  }
  skip_on_cran()

  mydsws <- dsws$new()

  myData <- mydsws$snapshotRequest(instrument = c("USTBI10" ,
                                                  "BMCN10Y(RY)-MLCNGIL(RY)",
                                                  "BMFR10Y(RY)-MLFRGIL(RY)",
                                                  "BMUK10Y(RY)-MLUKGIL(RY)",
                                                  "BMAU10Y(RY)-MLAUGIL(RY)",
                                                  "BMJP10Y(RY)-MLG0YIY(RY)"),
                                   expression = "XXXX",
                                   requestDate =  as.Date("2016-01-15"))

  expect_is(myData, "data.frame")
  expect_is(myData[1,2], "character")
  expect_equal(nrow(myData), 6)
  expect_equal(ncol(myData), 2)
  expect_true(!is.na(myData[1,2]))
  # Need a test that the cells do not contain $$"ER"

})



##############################################################################################

test_that("test that if INF is returned then it is not interpreted as Inf", {

  if (Sys.getenv("DatastreamUsername") == "") {
    skip("Username not available")
  }
  skip_on_cran()

  mydsws <- dsws$new()

  myData <- mydsws$snapshotRequest(instrument = c("INF"),
                                   datatype = c("NAME","MNEM","ISIN","RIC"),
                                   requestDate =  as.Date("2019-01-15"))

  expect_false(is.infinite(myData$Instrument[1]))
  expect_false(is.infinite(myData$MNEM[1]))

})


##############################################################################################

test_that("test for multicell dataitems", {

  if (Sys.getenv("DatastreamUsername") == "") {
    skip("Username not available")
  }
  skip_on_cran()

  mydsws <- dsws$new()
#  mydsws$jsonResponseSaveFile <- "VOD-QTEALL"
  myData <- mydsws$snapshotRequest(instrument = "VOD",
                                   datatype = "QTEALL",
                                   requestDate =  as.Date("2019-01-15"))

  expect_false(is.infinite(myData$Instrument[1]))
  expect_false(is.infinite(myData$CD01[1]))

})

test_that("test for multicell dataitems - multiple stocks", {

  if (Sys.getenv("DatastreamUsername") == "") {
    skip("Username not available")
  }
  skip_on_cran()

  mydsws <- dsws$new()
#  mydsws$jsonResponseSaveFile <- "VODHSBA-QTEALL"
  myData <- mydsws$snapshotRequest(instrument = c("VOD", "HSBA"),
                                   datatype = "QTEALL",
                                   requestDate =  as.Date("2019-01-15"))

  expect_false(is.infinite(myData$Instrument[1]))
  expect_false(is.infinite(myData$CD01[1]))

})


test_that("test for multicell dataitems - multiple stocks across chunks", {

  if (Sys.getenv("DatastreamUsername") == "") {
    skip("Username not available")
  }
  skip_on_cran()

  inst <- c("ADM", "AAL", "ANTO", "AHT", "ABF", "AZN", "AUTO", "AVV", "AV.",
            "BA.", "BARC", "BDEV", "BKG", "BHP", "BP.", "BATS", "BLND", "BT.A",
            "BNZL", "BRBY", "CCL", "CNA", "CCH", "CPG", "CRH", "CRDA", "DCC",
            "DGE", "EVR", "EXPN", "FERG", "FLTR", "FRES", "GSK", "GLEN",
            "HLMA", "HL.", "HIK", "HSX", "HSBA", "IMB", "INF", "IHG", "IAG",
            "ITRK", "ITV", "JD.", "JMAT", "JE.", "KGF", "LAND", "LGEN", "LLOY",
            "LSE", "MGGT", "MRO", "MNDI", "MRW", "NG.", "NXT", "NMC", "OCDO",
            "PSON", "PSN", "PHNX", "POLY", "PRU", "RB.", "REL", "RTO", "RMV",
            "RIO", "RR.", "RBS", "RDSA", "RDSB", "RSA", "SGE", "SBRY", "SDR",
            "SMT", "SGRO", "SVT", "SN.", "SMDS", "SMIN", "SKG", "SPX", "SSE",
            "STJ", "STAN", "SLA", "TW.", "TSCO", "TUI", "ULVR", "UU.", "VOD",
            "WTB", "WPP", "III")

  mydsws <- dsws$new()
  mydsws$chunkLimit <- 10
  myData <- mydsws$snapshotRequest(instrument = inst,
                                   datatype = "QTEALL",
                                   requestDate =  as.Date("2019-01-15"))

  expect_false(is.infinite(myData$Instrument[1]))
  expect_false(is.infinite(myData$CD01[101]))

})



