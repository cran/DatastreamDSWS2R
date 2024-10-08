##############################################################################################

context("classConstructor.R : test of listRequest method")

##############################################################################################

test_that("test of simple snapshot request for price datatype with relative dates", {

  if (Sys.getenv("DatastreamUsername") == "") {
    skip("Username not available")
  }
  skip_on_cran()



  mydsws <- dsws$new()

  myData <- mydsws$listRequest(instrument = "LFTSE100",
                                   datatype = "P",
                                   requestDate = "0D")

  expect_is(myData, "data.frame")
  expect_is(myData[1,2], "numeric")
  expect_gt(nrow(myData), 99)
  expect_equal(ncol(myData), 2)

})

test_that("test of simple snapshot request for price datatype with absolute dates", {

  if (Sys.getenv("DatastreamUsername") == "") {
    skip("Username not available")
  }
  skip_on_cran()



  mydsws <- dsws$new()

  myData <- mydsws$listRequest(instrument = "LFTSE100",
                               datatype = "P",
                               requestDate = Sys.Date())

  expect_is(myData, "data.frame")
  expect_is(myData[1,2], "numeric")
  expect_gt(nrow(myData), 99)
  expect_equal(ncol(myData), 2)

})


test_that("test of simple snapshot request for price datatype with relative dates", {
  if (Sys.getenv("DatastreamUsername") == "") {
    skip("Username not available")
  }
  skip_on_cran()


  mydsws <- dsws$new()

  myData <- mydsws$listRequest(instrument = "LFTSE100",
                               datatype = "NAME",
                               requestDate = "0D")

  expect_is(myData, "data.frame")
  expect_is(myData[1,2], "character")
  expect_gt(nrow(myData), 99)
  expect_equal(ncol(myData), 2)

})


test_that("test of simple snapshot request for Expression datatype with relative date", {
  if (Sys.getenv("DatastreamUsername") == "") {
    skip("Username not available")
  }
  skip_on_cran()


  mydsws <- dsws$new()

  myData <- mydsws$listRequest(instrument = "LFTSE100",
                               datatype = "458E(XXXX)",
                               requestDate = "0D")

  expect_is(myData, "data.frame")
  expect_is(myData[1,2], "character")
  expect_gt(nrow(myData), 99)
  expect_equal(ncol(myData), 2)

})


test_that("test of simple snapshot request for Date datatype with relative dates", {
  if (Sys.getenv("DatastreamUsername") == "") {
    skip("Username not available")
  }
  skip_on_cran()


  mydsws <- dsws$new()

  myData <- mydsws$listRequest(instrument = "LFTSE100",
                               datatype = "TIME",
                               requestDate = "0D")

  expect_is(myData, "data.frame")
  expect_is(myData[1,2], "Date")
  expect_gt(nrow(myData), 99)
  expect_equal(ncol(myData), 2)

})



test_that("Expect requests on different dates to give different responses", {
  if (Sys.getenv("DatastreamUsername") == "") {
    skip("Username not available")
  }
  skip_on_cran()


  mydsws <- dsws$new()

  myData <- mydsws$listRequest(instrument = "LFTSE100",
                               datatype = "TIME",
                               requestDate = as.Date("2019-10-01"))

  expect_is(myData, "data.frame")
  expect_is(myData[1,2], "Date")
  expect_gt(nrow(myData), 99)
  expect_equal(ncol(myData), 2)
  expect_equivalent(myData[1,2], as.Date("2019-10-01"))


})

