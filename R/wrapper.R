#' @include common.R
#' @include classConstructor.R
NULL

# This is a set of functions that will provide backwards compatability with
# the Datastream2R package


#  Functions are:
#     getDatastream - returns a connection to the DWE server and generate S3 objects
#     listRequest - Function that returns a the value of Expression for the instrument list in DSCode
#                In Datastream AFo this is Static request on a List eg LS&PCOMP
#     timeSeriesListRequest - Function that returns a set of timeseries for an instrument list eg LS&PCOMP
#     timeSeriesRequest - Function that returns a series of timeseries for a list of instruments
#
#




##############################################################################################
#'
#' @name getDataStream
#' @title Initialise connection with Datastream DSWS server (Depreciated)
#' @details Initialise connection with Datastream DSWS server.  Provided
#' for backwards compatibility
#' @description \code{getDataStream} initialises an R5 object that contains
#'  a connection with the Datastream DWE server.  This function has been
#'   provided for backward compatibility
#' @param dweURLwsdl Ignored
#' @param User Ignored - now sourced from options()$Datastream.Username
#' @param Pass Ignored - now sourced from options()$Datastream.Password
#' @return a dsws object
#'
#' @export
#'
getDataStream <- function(dweURLwsdl = "",
                          User=as.character("USERNAME"),
                          Pass=as.character("PASSWORD")
) {

  return(dsws$new())
}


###############################################################################################
#' @name timeSeriesRequest
#' @title make a timeseries request (Depreciated)
#'
#' @description make a timeseries request from the Datastream DSWS server
#' @details function \code{timeSeriesRequest} obtains a timeseries
#' from Datastream
#'
#' @param    dwei - A Datastream Client Interface object created with
#'  getDataStream
#' @param    DSCodes - one or more codes to return, eg "MKS" or
#' c("MKS","SAB")
#' @param    Instrument - the instrument or expression to return
#' eg PCH#(XXXX,1M)
#' @param    startDate - the start date of the timeseries
#' @param    endDate - the end date of the timeseries
#' @param    frequency - the frequency of the request
#' @param    sStockList - variable that is returned with list of the stocks
#' @param    aTimeSeries - variable that is returned with the set of
#'  timeseries.  This is a list that is not
#' guaranteed to be in the same order as sStockList
#' @param    myType - the type of the return values eg numeric
#' (default), Date or Character
#' @param    verbose - whether to give messages during the request
#'

#' @return    whether the request has been successful
#'    in sStockList: a list a two element vector of the displayname and
#'     symbol for each timeseries
#'    in aTimeseries: a list of class xts with the requested timeseries
#'     information
#'
#'
#' @export
timeSeriesRequest <- function(dwei=getDataStream(),
                              DSCodes="",
                              Instrument="",
                              startDate=Sys.Date(),
                              endDate=Sys.Date(),
                              frequency="D",
                              sStockList,
                              aTimeSeries,
                              myType = "numeric",
                              verbose=FALSE) {

  if (grepl(pattern = "XXXX", x = Instrument, fixed = TRUE) == FALSE) {
    # Instrument is not an expression if it does not contain 'XXXX
    myDataType <- Instrument
    myExpression <- ""
  } else {
    myDataType <- ""
    myExpression <- Instrument
  }


  myxts <- dwei$timeSeriesRequest(instrument = DSCodes,
                                  datatype = myDataType,
                                  expression = myExpression,
                                  startDate = startDate,
                                  endDate = endDate,
                                  frequency = frequency,
                                  format = "ByInstrument")

  myStockMap <- data.frame(displayname = DSCodes, symbol = colnames(myxts))
  eval.parent(substitute({sStockList <- myStockMap$displayname}))
  eval.parent(suppressWarnings(substitute({aTimeSeries <- myxts})))

  return(myStockMap)
}


##############################################################################################
#'
#' @name staticRequest
#' @title make a static request (Depreciated)
#'
#' @description makes a static (or snapshot request) from the
#' Datastream DSWS server
#' @details \code{staticRequest} Function that returns a the value of
#'  Expression for the array of instruments in DSCode from Datastream
#' parameters are
#'
#' @param dwei - A Datastream Client Interface object created with
#'  getDataStream
#' @param  DSCode - an array of instruments eg c("RIO","MKS")
#' @param  Expression - the data to return eg MNEM or NAME
#' @param  endDate - the date of the request, or the string "TODAY"
#' @param  frequency - the frequency of the request
#' @param   verbose - whether to give messages during the request
#' @param noCache - no longer used
#'
#' @return   returns an array of the requested information
#' @export

staticRequest <- function(dwei=getDataStream(),
                           DSCode,
                           Expression="",
                           endDate=Sys.Date(),
                           frequency="D",
                           verbose = FALSE,
                           noCache = FALSE) {

  myData <- dwei$snapshotRequest(instrument = DSCode,
                                 datatype = Expression,
                                 requestDate = endDate)

  return(myData)

}


##############################################################################################
#'
#' @name listRequest
#' @title Make a list request for static data (Depreciated)
#' @details Make a list request for static data
#' @description \code{listRequest} Function that returns a the value of
#' Expression for the instrument list in DSCode from Datastream
#'
#' @param dwei - A Datastream Client Interface object created with
#' getDataStream
#' @param  DSCode - the constituent list for the request eg LDJSTOXX
#' @param  Expression - the data to return eg MNEM or NAME.
#' If NULL or "" then we will return the code that has been loaded
#' into the User Created List.
#' @param  startDate - the date of the request, or the string "TODAY"
#' @param  endDate - Ignored
#' @param  frequency - the frequency of the request
#' @param  verbose - whether to give messages during the request
#'
#' @return  returns an array of the requested information
#' @export
#'

listRequest <- function(dwei=getDataStream(),
                         DSCode,
                         Expression = "",
                         startDate = Sys.Date(),
                         endDate = Sys.Date(),
                         frequency = "D",
                         verbose = FALSE) {

  myData <- dwei$listRequest(instrument = DSCode,
                             datatype = Expression,
                             expression = "",
                             requestDate = endDate)

  return(myData[ , 2:ncol(myData)])
}



##############################################################################################
#' @name  timeSeriesListRequest
#' @title make a timeSeries request for a list (Depreciated)
#' @details List request
#' @description  make a timeseries request for a constituent list from
#'  Datastream DSWS
#' \code{timeSeriesListRequest} Function that returns a timeseries from
#' Datastream constituent list parameters are
#' @param dwei - A Datastream Client Interface object created with
#'  getDataStream
#' @param DSCode - the constituent list requested eg 'LFTSE100'
#' @param Instrument - the expression to return for each member
#' of constituent list
#' @param startDate - the start date of the timeseries
#' @param endDate - the end date of the timeseries
#' @param frequency - the frequency of the request
#' @param sStockList - variable that is returned with list of of the stocks
#' @param aTimeSeries - variable that is returned with the set of timeseries
#' @param verbose - whether to give messages during the request
#'
#' @return   whether the request has been successful
#'    , but also
#'    in sStockList: a list a two element vector of the displayname
#'     and symbol for each timeseries
#'    in aTimeseries: a list of class xts with the requested
#'     timeseries information
#' @export
timeSeriesListRequest <- function(dwei = getDataStream(),
                                   DSCode,
                                   Instrument,
                                   startDate,
                                   endDate = Sys.Date(),
                                   frequency = "D",
                                   sStockList,
                                   aTimeSeries,
                                   verbose=FALSE) {


  if (grepl(pattern = "XXXX", x = Instrument, fixed = TRUE) == FALSE) {
    # Instrument is not an expression if it does not contain 'XXXX
    myDataType <- Instrument
    myExpression <- ""
  } else {
    myDataType <- ""
    myExpression <- Instrument
  }

  myxts <- dwei$timeSeriesListRequest(instrument = DSCode,
                                      datatype = myDataType,
                                      expression = myExpression,
                                      startDate = startDate,
                                      endDate = endDate,
                                      frequency = frequency,
                                      format = "ByInstrument")

  myStockMap <- dwei$getSymbolList()
  colnames(myStockMap) <- c("displayname", "symbol")
  eval.parent(substitute({sStockList <- myStockMap$displayname}))
  eval.parent(suppressWarnings(substitute({aTimeSeries <- myxts})))

  return(myStockMap)

}



##############################################################################################
#'
#' @name myStaticRequestSet
#' @title myStaticRequestSet (Depreciated)
#' @details Internal function
#' @description internal function for requesting an expression for an array of instruments.
#' The function will initially try a snapshot request, and if this
#' fails try a timeseries request.
#'
#' @param mydsws a dsws object, if not provided a new one will be created
#' @param instrument array of instruments
#' @param iExpression an expression such as PCH#(XXXX,1M)
#' @param endDate the date of the request
#' @param frequency optional frequency defaults to "D"
#'
#' @return a dataframe of the
#'
#' @importFrom xts last
#'
myStaticRequestSet <- function(mydsws = dsws$new(),
                               instrument,
                               iExpression,
                               endDate = Sys.Date(),
                               frequency = "D") {

  if (grepl(pattern = "XXXX", x = iExpression, fixed = TRUE) == FALSE) {
    idf <- tryCatch(mydsws$listRequest(instrument = instrument,
                                       datatype = iExpression,
                                       requestDate =  endDate),
                    error = function(e) return(NULL))
  } else {

    idf <- tryCatch(mydsws$listRequest(instrument = instrument,
                                       expression = iExpression,
                                       requestDate =  endDate),
                    error = function(e) return(NULL))

  }

  if (is.null(idf) || length(idf) == 0 || (is.character(idf[1, 2]) && idf[1,2] == "NA")
     | grepl(pattern = "$$\"ER\"", x = idf[1,2], fixed = TRUE) == TRUE) {
    # Assume a null means this is a timeseries expression
    if (grepl(pattern = "XXXX", x = iExpression, fixed = TRUE) == FALSE) {
      # Instrument is not an expression if it does not contain 'XXXX
      aTS <- mydsws$timeSeriesListRequest(instrument = instrument,
                                          datatype = iExpression,
                                          startDate =  endDate - 7,
                                          endDate =  endDate,
                                          frequency = frequency)
    } else {
      aTS <- mydsws$timeSeriesListRequest(instrument = instrument,
                                          expression = iExpression,
                                          startDate =  endDate - 7,
                                          endDate =  endDate,
                                          frequency = frequency)
    }

    idf <- t(last(aTS, 1))

  } else {
    idf <- idf[,2]

  }

  rownames(idf) <- NULL
  return(as.data.frame(idf, stringsAsFactors = FALSE))

}

##############################################################################################
#'
#' @name staticRequestSet
#' @title staticRequestSet
#' @details return a dataframe of static data
#' @description  This function creates a dataframe set of static requests for a set of stocks/indices
#'
#' @param mydsws a dsws object, if not provided a new one will be created
#' @param instrument array of instruments
#' @param expression an array of expressions such as PCH#(XXXX,1M) or Dataitems
#' @param endDate the date of the request
#' @param frequency optional frequency defaults to "D"
#' @param verbose whether to display messages as making the request
#'
#' @return a dataframe of the data
#'
#' @importFrom xts last
#' @importFrom foreach foreach %do%
#'
#' @export
#'
staticRequestSet <- function(mydsws = dsws$new(),
                             instrument,
                             expression = "",
                             endDate = Sys.Date(),
                             frequency = "D",
                             verbose = FALSE) {

  iExpression <- NULL

  ldf <- foreach(iExpression = expression) %do%
    {
      if (grepl(pattern = "XXXX", x = iExpression, fixed = TRUE) == FALSE) {
        # Instrument is not an expression if it does not contain 'XXXX
        idf <- mydsws$snapshotRequest(instrument = instrument,
                                      datatype = iExpression,
                                      requestDate =  endDate)
      } else {
        idf <- mydsws$snapshotRequest(instrument = instrument,
                                      expression = iExpression,
                                      requestDate =  endDate)
      }

      if (length(idf) == 0 | grepl(pattern = "$$\"ER\"", x = idf[1,2], fixed = TRUE) == TRUE) {
        #
        if (grepl(pattern = "XXXX", x = iExpression, fixed = TRUE) == FALSE) {
          # Instrument is not an expression if it does not contain 'XXXX
          aTS <- mydsws$timeSeriesRequest(instrument = instrument,
                                          datatype = iExpression,
                                          startDate =  endDate - 7,
                                          endDate =  endDate,
                                          frequency = frequency)
        } else {
          aTS <- mydsws$timeSeriesRequest(instrument = instrument,
                                          expression = iExpression,
                                          startDate =  endDate - 7,
                                          endDate =  endDate,
                                          frequency = frequency)
        }
        idf <- t(unlist(last(aTS, 1)))
        if (length(idf) == 0) {
          #If we still do not have anything valid then return a column of NULLs
          idf <- data.frame(matrix(NA, nrow = length(instrument), ncol = 1))
          colnames(idf) <- iExpression
        }
      } else {
        idf <- idf[,2]
      }

      as.data.frame(idf)
    }

  df <- bind_cols(ldf)
  colnames(df) <- expression
  rownames(df) <- NULL
  return(as.data.frame(df))
}


##############################################################################################
#'
#' @name staticListRequestSet
#' @title staticListRequestSet
#'
#' @details This function creates a dataframe set of static list requests for a constituent list
#' @description This function creates a dataframe set of static list requests for a constituent list
#' @param mydsws a dsws object, if not provided a new one will be created
#' @param instrument array of instruments
#' @param expression an array of expressions such as PCH#(XXXX,1M)
#' @param endDate the date of the request
#' @param frequency optional frequency defaults to "D"
#'
#' @return a dataframe of the data
#'
#' @importFrom xts last
#' @importFrom foreach foreach %do%
#' @importFrom dplyr bind_cols
#'
#' @export
#'
staticListRequestSet <- function(mydsws = dsws$new(),
                                 instrument,
                                 expression = "",
                                 endDate = Sys.Date(),
                                 frequency = "D") {

  iExpression <- NULL

  ldf <- foreach(iExpression = expression) %do%
    {
      myStaticRequestSet(mydsws = mydsws,
                         instrument = instrument,
                         iExpression = iExpression,
                         endDate = endDate,
                         frequency = frequency)
    }

  df <- bind_cols(ldf)
  rownames(df) <- NULL
  colnames(df) <- expression
  return(as.data.frame(df))
}

