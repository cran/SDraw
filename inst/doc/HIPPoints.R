## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
set.seed(93954)

## ----import, echo=TRUE---------------------------------------------------
library(SDraw)

## ----smallSample---------------------------------------------------------
n <- 5
N <- 14
x <- rnorm(N,0,1)
y <- rnorm(N,0,1)
sp <- SpatialPoints(cbind(x,y))
plot(sp, pch=1)

## ----smallSampling, echo=TRUE--------------------------------------------
s <- sdraw(sp, n, "HIP", plot.lattice=TRUE)

## ----largeSampling, echo=TRUE--------------------------------------------
data(WA.cities)
n <- 150
s <- sdraw(WA.cities, n, "HIP")
plot(WA)
points(WA.cities)
points(s, col="red", pch=19)

