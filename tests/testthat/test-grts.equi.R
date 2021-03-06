##Load a pre-built dataset
##This object needs to be a global variable, hence assignment
##and generation outside of the main test function. 
data(meuse)

##Assign the 3 components: coordinates, data, and proj4string

coords <- meuse[ , c("x", "y")]   # coordinates
data   <- meuse[ , 3:14]          # data
crs    <- CRS("+init=epsg:28992") # proj4string of coords

##Assign a spatial points data frame object from the 3 generated arguments
spdf <- SpatialPointsDataFrame(coords = coords,
                               data = data, 
                               proj4string = crs)


context("Test the grts.equi function") 


test_that("grts.equi() operates appropriately", {
  
  ##This function operates on two different inheritance classes; integers and SPDF objects 
  ##Begin by testing when over.n == 0
  expect_type(obj <- grts.equi(spdf, 20, 0), "S4")
  expect_visible(grts.equi(spdf, 20, 0), c("sampleID"))
  
  ##Check that the SPDF object is formatted correctly when passing through this function
  expect_named(grts.equi(spdf, 15, 3), c('sampleID',
                                         'pointType',
                                         'geometryID',
                                         'cadmium',
                                         'copper',
                                         'lead',
                                         'zinc',
                                         'elev',
                                         'dist',
                                         'om',
                                         'ffreq',
                                         'soil',
                                         'lime',
                                         'landuse',
                                         'dist.m'))
  expect_identical((grts.equi(spdf, 1, 0)$sampleID), "Site-1")
  expect_identical((grts.equi(spdf, 1, 0)$pointType), "Sample")
  
  ##Check for bad data
  expect_error(grts.equi(mtcars, 5, 0))
  expect_error(grts.equi(spdf, 158, 0))
  
})