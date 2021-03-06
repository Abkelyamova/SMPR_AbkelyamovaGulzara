euclideanDistance <- function(u, v) 
{
     sqrt(sum((u - v) ^ 2))
}
sortObjectsByDist <- function(xl, z, metricFunction = euclideanDistance)
{
      l <- dim(xl)[1] 
      n <- dim(xl)[2] - 1
      distances <- matrix(NA, l, 2) 
      for (i in 1:l) 
      {
          distances[i,] <- c(i, metricFunction(xl[i, 1:n], z))
      }
      orderedXl <- xl[order(distances[, 2]),] 
      return (orderedXl)
}
kNN <- function(xl, z, k, orderedXl) 
{
      #orderedXl <- sortObjectsByDist(xl, z, euclideanDistance) 
      n <- dim(orderedXl)[2] - 1 
      classes <-orderedXl[1:k, n + 1] 
      counts <- table(classes)
      class <- names(which.max(counts)) 
      return (class)
}
LOO <- function(xl,class) 
{
      n <- dim(xl)[1];
      loo <- rep(0, n-1) 
      for(i in 1:n)
      {
             X <- xl[-i, 1:3]
             u <- xl[i, 1:2]
             orderedXl <- sortObjectByDist(X, u)
             for(k in 1:(n-1))
             {
                     test <- knn(X,u,k,orderedXl)
                     if(colors[test] != colors[class[i]])
                     {
                            loo[k] <- loo[k]+1;
                     }
             }
      }
      loo <- loo / n
      x <- 1:length(loo)
      y <- loo
      plot(x, y,main ="График зависимости LOO от k для KNN", xlab="k", ylab="LOO", type = "s")
      min <- which.min(loo)
      lOOmin  <- round(loo[min],3)
      points(min, loo[min], pch = 21, col = "red",bg = "red")
      label <- paste("   K = ", min,  sep = "")
      xmin <- 3*min;
      text(xmin, lOOmin, labels = label, pos = 3, col = "black")
}
colors <- c("setosa" = "red", "versicolor" = "green3","virginica" = "blue")
xl <- iris[, 3:5] 
class <- iris[, 5]
LOO(xl,class)
