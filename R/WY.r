#' @title SpatialPolygonsDataFrame of counties in the state of Wyoming, USA
#' 
#' @description A \code{SpatialPolygonsDataFrame} containing polygons 
#' for the 23 counties in the state of Wyoming. 
#' 
#' @usage data("WY")
#' 
#' @format
#' A \code{SpatialPolygonsDataFrame} containing 23 polygons whose union outline 
#' boundaries of the state of Wyoming. Source of the Shapefile containing all US 
#' counties in 2015 was 
#' \url{https://www.census.gov/geo/maps-data/data/cbf/cbf_counties.html}.
#' 
#' Attributes of the polygons are:
#' \enumerate{
#'  \item  STATEFP = State identifier (56 = Wyoming)
#'  \item  COUNTYFP = Unique identifier for county
#'  \item  NAME = Name of the county
#' }
#'
#' The proj4string is \code{"+init=epsg:26912} \code{+proj=utm} \code{+zone=12} \code{+datum=NAD83} 
#' \code{+units=m} \code{+no_defs} \code{+ellps=GRS80} \code{+towgs84=0,0,0"}, 
#' meaning among other things that the coordinates are projected zone 12 UTM's in meters. 

#' The rectangular bounding box of all polygons is
#'  
#' \tabular{lrr}{
#' \tab       min  \tab      max \cr
#' x \tab  495506 \tab   1084419 \cr
#' y \tab  4538294 \tab  5006162 \cr
#' }
#' 
#' @examples
#'plot(WY, col=rainbow(length(WY)))
#'@name WY
NULL
