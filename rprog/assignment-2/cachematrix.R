## In order to save computing cycles especially in repeated calculations, 
## we can use lexical scoping rules to cache the results of a calculation
## in a local field of an object.

## make a special "matrix" object which can cache its inverse.
## methods getInverse() and setInverse() are used for setting and
## getting the cached values. Methods get() and set() are used to
## store the matrix itself.
makeCacheMatrix <- function(x = matrix()) {
  m <- NULL
  set <- function(y) {
    x <<- y
    m <<- NULL
  }
  get <- function() x
  setInverse <- function(inverse) m <<- inverse
  getInverse <- function() m
  list(set = set, get = get, setInverse = setInverse, getInverse = getInverse)
}


## this method tries to first pull the cached value from a 
## makeCacheMatrix-object. In case it exists, no further calculations
## are done, but the cached value is returned. In case, the value
## has not yet been calculated, we calculate it, and store it in
## the cache of the makeCacheMatrix object.
cacheSolve <- function(x, ...) {
        ## Return a matrix that is the inverse of 'x', if exists.
  m <- x$getInverse()
  if (!is.null(m)) {
    message("getting cached data")
    return(m)
  }
  data <- x$get()
  m <- solve(data, ...)
  x$setInverse(m)
  m
}
