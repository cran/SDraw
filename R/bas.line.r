#' @export bas.line
#' 
#' @title Draws a Balanced Acceptance Sample (BAS) from a linear resource (line).
#' 
#' @description Draws a BAS sample from a \code{SpatialLines*} object.
#' 
#' 
#' @param n Sample size.  Number of locations to draw from the set of all lines
#' contained in \code{x}.
#' @param x A \code{SpatialLines} or \code{SpatialLinesDataFrame} object. This object must
#' contain at least 1 line.  If it contains more than 1 line, the BAS sample is
#' drawn from the union of all lines.
#' 
#' @param balance Option specifying how spatial balance is maintained. The options
#' are "1D" or "2D".  
#' 
#' Under "1D" all lines in \code{x} are stretched straight 
#' and laid end-to-end in the order they appear in \code{x} and a 1-dimensional 
#' BAS sample is taken from the amalgamated line.  1D sample locations on the 
#' amalgamated line are  
#' mapped back to two dimensional space for output and 
#' appear on the original lines.  This
#' method maintains 1D spatial balance, but not necessarily 2D balance.  Spatially 
#' balanced samples in 1D may not look spatially balanced when plotted 
#' in 2 dimensions.   
#' 
#' Under "2D" a systematic sample of points along the union of all lines 
#' in \code{x} is drawn first, and a 2-dimensional BAS sample of the points
#' is drawn (see \code{init.n.factor} below and \code{\link{bas.point}}).  
#' This maintains 2D spatial balance of sample locations on the lines. Depending 
#' on \code{init.n.factor}, the "2D" balance option can take significantly 
#' longer to run than the "1D" option.
#'     
#' @param init.n.factor If \code{balance == "2D"}, this is a 
#' scalar controlling the number of points to
#' place on the lines before drawing the 2D BAS sample.  
#' Number of points created on the line is
#' \code{n*init.n.factor}, so this number can grow quickly.  On average, this
#' is the number of un-selected points between each selected point.  See
#' Details.
#' 
#' If one desires an underlying grid spaced \emph{w} meters apart, set 
#' \code{init.n.factor} to \emph{L/(w*n)}, where \emph{L} is total length 
#' of all lines in \code{x} and \emph{n} is sample size.
#' 
#' @details 
#' If a "1D" sample is requested, spatial balance is maintained on the 
#' lines when laid end-to-end in the order they appear.  Points far apart 
#' in 1 dimension may be close together in 2 dimensions, and vice versa. 
#' Thus the sample may not look spatially balanced on a 2D map. This is a 
#' true infinite sample in that any of an infinite number of points 
#' along the lines could be selected.
#' 
#' If a "2D" BAS sample is requested, spatial balance is maintained 
#' in 2 dimensions.  Points are well balance on a 2D map.  This is 
#' done by discretization of lines with a dense systematic 
#' sample of points (with 
#' random start) where density of the systematic points is controlled 
#' by \code{init.n.factor}.  After
#' discretization of the line, points are selected 
#' using \code{\link{bas.point}}.  The BAS method for points places
#' a small square (pixel) around each and samples the set of squares
#' using the BAS method for polygons (see \code{\link{bas.polygon}}).  The BAS
#' method of polygons computes Halton points until \code{n} fall
#' inside the squares surrounding discretization points.  When a 
#' Halton
#' point falls in a square, the square is selected and the 
#' sample location is the center of the square (which falls somewhere on the
#' original lines).
#' 
#' @return A \code{SpatialPointsDataFrame} containing locations in the BAS sample, 
#' in BAS order.
#'  Attributes of the sample points are: 
#' \itemize{
#'   \item \code{sampleID}: A unique identifier for every sample point.  This 
#'   encodes the BAS order.  If BAS order is lost, \code{return[} \code{order(} 
#'   \code{return$sampleID} \code{),]} will resort the 
#'   returned object (i.e., \code{return}) into BAS order.
#'   
#'   \item \code{geometryID}: The ID of the line in \code{x} on which each 
#'   sample point falls.  The 
#'   ID of lines in \code{x} are \code{row.names(x)}. 
#'   \item Any attributes of the original lines (in \code{x}). 
#' }
#'
#' Additional attributes of the output object, beyond those which 
#' make it a \code{SpatialPointsDataFrame}, are:
#' \itemize{
#'    \item \code{frame}: Name of the input sampling frame.
#'    \item \code{frame.type}: Type of resource in sampling frame. (i.e., "line").
#'    \item \code{sample.type}: Type of sample drawn. (i.e., "BAS").
#'    \item \code{balance}: The type of balance ("1d" or "2d").
#'    \item \code{random.start}: The random seed for the random-start 
#'    1D or 2D Halton sequence 
#'    that produced the sample.  
#'    If \code{balance=="1D"}, this is a single uniform random 
#'    integer between 0 and \code{\link{maxU}}. If \code{balance=="2D"}, this is 
#'    a vector of two uniform random 
#'    integers between 0 and \code{\link{maxU}}.  
#'    
#'    \item \code{bas.bbox}: If \code{balance=="2D"}, this is the 
#'    bounding box surrounding \code{x}
#'    used to scale Halton points.  The scaled Halton sequence is 
#'    \code{bas.bbox[,"min"]+} \code{t(halton(n,2,random.start))*} 
#'    \code{rep(max(} \code{diff(t(bas.bbox))),} \code{2)}.
#'    If \code{balance=="1D"}, this is a vector containing the 1D 
#'    bounding box. Lower limit of the 1D bounding box is 0.  Upper
#'    limit of the 1D box is the total 
#'    length of lines in \code{x}.  In this case, Halton points 
#'    are scaled as \code{bas.bbox[,"min"]+} \code{halton(n,1,random.start)*} 
#'    \code{diff(bas.bbox)} which is equivalent to \code{halton(n,1,} \code{random.start)*} 
#'    \code{bas.bbox[2]} because \code{bas.bbox[1]} is zero.
#' }
#' 
#' @author Trent McDonald
#' @seealso \code{\link{bas.line}}, \code{\link{bas.polygon}}, \code{\link{sdraw}}
#' @keywords design survey
#' @examples
#' 
#' #   Draw sample of Hawaii coastline
#' #   This takes approximately 60 seconds to run
#' samp <- bas.line( HI.coast, 50 )
#' plot(HI.coast)
#' points( samp, pch=16, col="red" )
#' 
#' 
bas.line <- function(x, n, balance="1D", init.n.factor=10){

#   Function to draw a bas sample from a shapefile
#   containing linear 1-d features.


if( !inherits(x, "SpatialLines") ) stop("Must call bas.line with a SpatialLines* object.")

##   Check for projected coordinates and convert if necessary.
#ps <- proj4string(x)
#if( regexpr("proj=longlat", ps) > 0 ){
#    #   We have a lat-long system  - Issue a warning
#    warning( paste("SDRAW: Lat-Long coordinate system found. Recommend conversion of \n",
#    "original spatial lines to UTM and re-drawing sample. Use of Lat-Long will slightly reduce\n", 
#    "spatial balance when sampling long lines."))
#}

if( tolower(balance) == "2d"){
  #   Discretize the line with n.pixel.factor more points than needed for sample
  pt.frame <- sss.line( x, n*init.n.factor )
  
  #   Sample as points
  samp <- bas.point( pt.frame, n )
  
  attr(samp, "frame") <- deparse(substitute(x))  
  attr(samp, "frame.type") <- "line"
  attr(samp, "balance") <- tolower(balance)

} else {
  # Get all coordinates from all lines "back to back" in a matrix
  mline.ids <- merge.lines(x)
  mline <- mline.ids$geometry
  mline.ids <- mline.ids$IDs
  
  # Figure out l.out sequence along parameterized line ("l","x","y")
  tot.len <- mline[nrow(mline),"l"]
  names(tot.len) <- NULL  # wipe out name so attribute bas.bbox and proper names
  if (exists("maxU", envir = .GlobalEnv, mode="function")) {
    max.u <- get( "maxU", envir=.GlobalEnv, mode="function" )
    max.u <- max.u()
  } else {
    max.u <- SDraw::maxU()
  }
  m <- floor((max.u+1) * runif( 1 )) # only one dimension here
  hal.pts <- halton(n, dim=1, start=m )
  l.out <- hal.pts * tot.len
  
  # Extract or compute points on the parameterized line, and indices (tt)
  x.out <- aprox( mline[,"l"], mline[,3], l.out)
  y.out <- aprox( mline[,"l"], mline[,4], l.out)
  t.out <- aprox( mline[,"l"], mline[,"t"], l.out)
  
  # Extract line ID's at each point
  geoID.out <- mline.ids[ceiling(t.out)]

  # output ===========================================================
  crds <- data.frame(x.out,y.out)
  names(crds)<- dimnames(mline)[[2]][3:4]
  row.names(crds) <- 1:length(x.out)
  samp<-SpatialPoints( crds, proj4string = CRS(proj4string(x)) )
  
  if( inherits(x, "SpatialLinesDataFrame") ){
    # x has attributes, extract them at the points
    df <- data.frame(x)[geoID.out, ]
    df <- data.frame( sampleID=1:length(x.out), geometryID=geoID.out, df)
    row.names(df) <- 1:length(x.out)
  } else {
    df <- data.frame( sampleID=1:length(x.out), geometryID=geoID.out )
    row.names(df) <- 1:length(x.out)
  }
  samp <- SpatialPointsDataFrame(samp, df, proj4string = CRS(proj4string(x)), match.ID = TRUE)
  
  attr(samp, "frame") <- deparse(substitute(x))
  attr(samp, "frame.type") <- "line"
  attr(samp, "balance") <- tolower(balance)
  attr(samp, "sample.type") <- "BAS"
  attr(samp, "random.start") <- m
  attr(samp, "bas.bbox") <- c(min=0,max=tot.len)
  
}
  
samp

}
