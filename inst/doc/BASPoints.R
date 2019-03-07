## ------------------------------------------------------------------------
library(sp)
# Create the bounding study area as a single polygon 
study.area <- Polygon( data.frame(x=c(0,100,100,0,0), y=c(0,0,100,100,0)) )
study.area <- Polygons(list(study.area), "1")
study.area <- SpatialPolygons(list(study.area))
# Create population of points
popln.points <- GridTopology( c(5,5), c(10,10), c(10,10) )
popln.points <- SpatialGrid(popln.points)
popln.points <- SpatialPoints(popln.points)
# Create population of pixels for visualization and sample selection
popln.pixels <- SpatialPixelsDataFrame(popln.points, data.frame(val=1:100))

## ----fig.width=6.5,fig.height=6.5,fig.cap="Example population with base c(2,3) Halton boxes plotted. Population consists of 100 points in regular grid.  Study area extent is 100 X 100 units.  Point coordinates are 5, 15, 25, ..., 95"----
plot(popln.pixels, what="image", axes=TRUE, xaxt="n",yaxt="n")
axis(2, at=seq(5,100,by=10), labels = FALSE)
axis(2, at=seq(5,95,by=20), labels = seq(5,95,by=20))
axis(1, at=seq(5,100,by=10), labels = FALSE)
axis(1, at=seq(5,95,by=20), labels = seq(5,95,by=20))
points(popln.points, pch=16, col="red")

abline(v=c(1/2)*100)
abline(h=c(1/3,2/3)*100)

## ------------------------------------------------------------------------
library(SDraw)
random.start <- floor(runif(2,max=maxU()+1))
random.start

## ------------------------------------------------------------------------
n <- 12
halt.seq <- halton(n, dim=2, start=random.start, bases=c(2,3))
# The unscaled random start Halton sequence
halt.seq
# The scaled random start Halton sequence
halt.seq <- halt.seq * 100
halt.seq

## ----echo=F,fig.width=6.5,fig.height=6.5---------------------------------
plot(popln.pixels, what="image", axes=TRUE, xaxt="n",yaxt="n")
axis(2, at=seq(5,100,by=10), labels = FALSE)
axis(2, at=seq(5,95,by=20), labels = seq(5,95,by=20))
axis(1, at=seq(5,100,by=10), labels = FALSE)
axis(1, at=seq(5,95,by=20), labels = seq(5,95,by=20))
points(popln.points, pch=16, col="red")

abline(v=c(1/2)*100)
abline(h=c(1/3,2/3)*100)

points(halt.seq[,1], halt.seq[,2], pch=15, col="orange", cex=1.5)
points(halt.seq[,1], halt.seq[,2], pch=3, col="black", cex=1.5)

## ----echo=F,fig.width=6.5,fig.height=6.5,fig.cap="Study area with 72 Halton points. Exactly 2 Halton points appear in each of the 36 Halton boxes."----
plot(popln.pixels, what="image", axes=TRUE, xaxt="n",yaxt="n")
axis(2, at=seq(5,100,by=10), labels = FALSE)
axis(2, at=seq(5,95,by=20), labels = seq(5,95,by=20))
axis(1, at=seq(5,100,by=10), labels = FALSE)
axis(1, at=seq(5,95,by=20), labels = seq(5,95,by=20))
points(popln.points, pch=16, col="red")

abline(v=((1:3)/4)*100, lty=2)
abline(h=((1:8)/9)*100, lty=2)
abline(v=c(1/2)*100, lwd=2)
abline(h=c(1/3,2/3)*100, lwd=2)

rs.halt.seq <- halton(72, dim=2, start=random.start, bases=c(2,3))
rs.halt.seq <- rs.halt.seq * 100

points(rs.halt.seq[,1], rs.halt.seq[,2], pch=15, col="orange", cex=1.5)
points(rs.halt.seq[,1], rs.halt.seq[,2], pch=3, col="black", cex=1.5)

## ------------------------------------------------------------------------
# Simple method to determine sampled points.  
x.cell <- floor(halt.seq[,1]/10)
y.cell <- floor(halt.seq[,2]/10)

x.pt <- x.cell*10 + 5
y.pt <- y.cell*10 + 5

bas.samp <- data.frame(x=x.pt, y=y.pt)
bas.samp

## ------------------------------------------------------------------------
bas.samp <- SpatialPoints(bas.samp)
bas.samp

## ----echo=F,fig.width=6.5,fig.height=6.5,fig.cap="Example study area with n = 12 selected points (filled circles)."----
plot(popln.pixels, what="image", axes=TRUE, xaxt="n",yaxt="n")
axis(2, at=seq(5,100,by=10), labels = FALSE)
axis(2, at=seq(5,95,by=20), labels = seq(5,95,by=20))
axis(1, at=seq(5,100,by=10), labels = FALSE)
axis(1, at=seq(5,95,by=20), labels = seq(5,95,by=20))
points(popln.points, pch=1, col="red")
points(bas.samp, pch=15, col="red")

## ------------------------------------------------------------------------
halt.pts <- SpatialPoints(halt.seq)
keep <- over( halt.pts, popln.pixels)
bas.samp <- popln.pixels[keep$val,]
bas.samp

