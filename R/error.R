# devuelve el mayor valor de x que esté en y
apariciones_menor <- function(x,y) {
  Mayor <- 0
  Mayor <- max(x)
  Peque <- 0
  peque <- min(x)
 
  v = y==Peque
  return(sum(v))
}

apariciones_menor(c(5,2,8,9),c(4,2,2,4,3))