nreps <- 10000
sum <- 0

for (i in 1:nreps) {
    x <- sample(1:14, 1)
    if (x == 3) {
        if (runif(1) < 0.5) {
            y <- 10
        }
        else {
            y <- 14
        }
    }
    else {
        if (runif(1) < 0.14) {
            y <- 10
        }
        else {
            y <- 14
        }
    }
    y_squared = y * y
    temp <- x * y_squared
    sum <- sum + temp
}

print(sum/nreps)