# DatastreamDSWS2R
Functions and a R5 class that allows data to be downloaded and uploaded to the Refinitiv Datastream database via the DSWS server.  Refinitiv Datastream is a rich database of financial information and details are available at <https://developers.refinitiv.com/en>.  You need to have a Datastream subscription and a username/password to use this package.

The package can be installed using:

    require(devtools)
    install_github(“CharlesCara/DatastreamDSWS2R”)

Your Refinitiv Datastream username and password are best stored in environment variables by adding to your .Renviron file the following
lines.  This approach makes DatastreamDSWS2R able to be run securely in Docker containers by passing the credentials into the container at
runtime.

    DatastreamUsername=YOURUSERNAME
    DatastreamPassword=YOURPASSWORD

For backwards compatibility we have retained the ability to put credentials into options().  In this scenario you would add these lines to your .RProfile file:

    options(Datastream.Username = "YOURUSERNAME")
    options(Datastream.Password = "YOURPASSWORD")

## Static Requests
Once set up a typical request would be for a snapshot or *static* request:

     mydsws <- dsws$new()
     myData <- mydsws$snapshotRequest(instrument = c("ABF","RIO","WPP"),
                                   datatype = "P",
                                   requestDate = "0D")

or with expressions (including E codes), where "X" is replaced by "XXXX":

     mydsws <- dsws$new()
     myData <- mydsws$snapshotRequest(instrument = c("ABF","RIO","WPP"),
                                   expression = "PCH#(XXXX,3M)",
                                   requestDate = "0D")

and for a constituent list request (expressions are also supported)

    mydsws <- dsws$new()
    myData <- mydsws$listRequest(instrument = "LFTSE100", datatype = "P", requestDate = "0D")

We have created a set of functions that hide the reference class structure.

For example, **last update** can be queried either like this: 

    mydsws <- dsws$new()
    mydsws$snapshotRequest(instrument = c("SWCNB10","UKEUSCCIR"), 
                         datatype = c("MNEM","UPDATE"), 
                         requestDate = "0D")

or like this:

    mydsws <- dsws$new()
    staticRequest(mydsws, c("SWCNB10","UKEUSCCIR"), c("MNEM","UPDATE"), "0D")

We can also handle composite datatypes that return multiple values, for instance datatype QTEALL, which returns details of associated stocks.

    mydsws <- dsws$new()
    mydsws$snapshotRequest(instrument = c("VOD", "HSBA"),
                           datatype="QTEALL",
                           requestDate = Sys.Date())


Another notable dataitem that returns multiple values is 'DS.USERSTATS' which returns information on the user's consumption of Datastream data.

    mydsws <- dsws$new()
    mydsws$snapshotRequest(instrument = "STATS",
                           datatype = "DS.USERSTATS",
                           requestDate = Sys.Date())



## Timeseries requests
Timeseries request (expressions are also supported) using the timeSeriesRequest and timeSeriesListRequest methods

    mydsws <- dsws$new()
    xtsData <- mydsws$timeSeriesRequest(instrument = "MKS",
                           datatype = "MV",
                           startDate = "-30D",
                           endDate = "-0D",
                           frequency = "D")

    xtsData <- mydsws$timeSeriesListRequest(instrument = "LFTSE100",
                           datatype = "MV",
                           startDate = "-30D",
                           endDate = "-0D",
                           frequency = "D")


## Other information
The dsws interface will split large requests down into chunks small enough for the DSWS interface to process.  However, the maximum chunk size varies in the DSWS documentation and is either 2000 or 50.  Different users have different limits.  The default chunkLimit is 2000, but it can be to 50:

    mydsws <- dsws$new()
    mydsws$chunkLimit <- 50L

Alternatively this can be set as an option by adding this line to your .RProfile file.

    options(Datastream.ChunkLimit = 50L)

## Storage of DSWS access token between sessions

The access token that is used to access DSWS can be provided via a callback function. This allows
the callback function to cache the token between sessions and so reducing the number of calls on the DSWS server.

When the token expires then this function will be called again and needs to provide a refreshed token.  The callback function is used like this: 

    # Stub of function for returning token from user's cache
    myTokenFunc <- function(){
        return(list(TokenValue = "abc",
                    TokenExpiry = as.POSIXlt("2020-04-17 12:34")))
    }

    mydsws <- dsws$new(getTokenFunction = myTokenFunc)



## Update 1.7.5
Improvement in handling of Token Callback function.

## Update 1.7.4
Fix for Issues #37 - charToDate error raised when list request had mixture of dates and character "NA""

## Update 1.7.2
Fix for Issues #20 - requesting token after http 403 response

## Update 1.7.1
Fix for Issue #28 - callback function for getting token 


## Update 1.6.6
Fix for Issues #26 and #27

## Update 1.6.3
Handle lower case RIC codes.

## Update 1.6.2
Improve documentation and return Instrument column in snapshot requests.

## Update 1.6.1
Added handling of composite datatypes which return multiple values.

## Update 1.5.1
With this update we have switched from using the RCurl/rjson to using the httr/jsonlite packages for communicating with the Datastream server. 


## CRAN
Thank you to @mbannert for his work making the package ready to be released on CRAN. 


