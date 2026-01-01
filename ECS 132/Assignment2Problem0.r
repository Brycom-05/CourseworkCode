nreps <- 10000
Xplus4Ysum <- 0
Xplus4Ysumsquared <- 0
for (i in 1:nreps) {
    X <- sample(c(1, 2, 5), 1, 0, c(0.1, 0.8, 0.1))
    if (X == 2) {
        if (runif(1) < 0.5) {
            Y <- 0
        }
        else {
            Y <- 1
        }
    }
    else {
        if (runif(1) < 0.34) {
            Y <- 0
        }
        else {
            Y <- 1
        }
    }
    Ytimes4 <- 4 * Y
    temp <- X + Ytimes4
    tempsquared <- temp * temp
    Xplus4Ysum <- Xplus4Ysum + temp
    Xplus4Ysumsquared <- Xplus4Ysumsquared + tempsquared
}

EXplus4Y <- Xplus4Ysum / nreps
EXplus4Ysquared <- Xplus4Ysumsquared / nreps

EXplus4Y_squared <- EXplus4Y * EXplus4Y

variance <- EXplus4Ysquared - EXplus4Y_squared
print(variance)