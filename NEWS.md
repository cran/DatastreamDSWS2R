## Update 1.7.9
Internal changes to package to make it pass CRAN checks and policies.

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

## Datastream DWE - now decommissioned by Refinitiv
In addition, this package has been built to be largely backwards compatible with 
the Datastream2R package that used the depreciated DWE 
server from Datastream.  You just need to replace 
    require(Datastream2R) 
with 
    require(DatastreamDSWS2R)

## CRAN
Thank you to @mbannert for his work making the package ready to be released on CRAN. 


