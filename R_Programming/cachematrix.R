## Matrix inversion is usually a costly computation and there may be some 
## benefit to caching the inverse of a matrix rather than compute it repeatedly.
## This function creates a special "matrix" object that can cache its inverse.
## The first function, makeCacheMatrix creates a special "matrix", which is 
## really a list containing a function to
##   1. set the value of the vector
##   2. get the value of the vector
##   3. set the value of the mean
##   4. get the value of the mean

makeCacheMatrix <- function(x = matrix()) {
        inv <- NULL           ## inv is assigned the value NULL
        set <- function(y) {  ## set function
                x <<- y           ## substitutes the matrix x with matrix y
                inv <<- NULL      ## inv is assigned the value NULL
        }
        get <- function() x   ## get function returns the original matrix
        setinverse <- function(inverse) inv <<- inverse  ## inv is assigned the value inverse
        getinverse <- function() inv                     ## computes the inverse of the matrix
        list(set = set, get = get, setinverse = setinverse, getinverse = getinverse)
}                         ## stores the value of set, get, setinverse, and getinverse in a list

## The function below computes the inverse of the special "matrix" returned by 
## makeCacheMatrix above. it first checks to see if the inverse has already been 
## calculated. If so, it gets the inverse from the cache and skips the computation. 
## Otherwise, it calculates the inverse of the matrix and sets the value of the
## inverse in the cache via the setinv function.

cacheSolve <- function(x, ...) {
        inv <- x$getinverse()                ## getinverse obtains the stored computed inverse of the matrix   
        if(!is.null(inv)) {                  ## if there is a stored value for the inverse of the matrix
                message("getting cached data") ## the message "getting cached data" is returned and
                return(inv)                    ## the value of the stored computed inverse of the matrix is returned
        }                                    ## if there is no stored value for the inverse of the matrix
        data <- x$get()                      ## the original matrix is retrieved and
        inv <- solve(data, ...)              ## the inverse of the matrix is computed and
        x$setinverse(inv)                    ## the inverse of the matrix is stored
        inv
}
