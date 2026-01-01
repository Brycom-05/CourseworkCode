nreps <- 10000
iter <- 100
probWin <- 0.14
sumEX <- 0
sumEX_squared <- 0

for (i in 1:nreps) {
    sum <- 0
    for (j in 1:iter) {
        if (runif(1) < probWin) {
            sum <- sum + 1
        }
    }
    EX <- sum/iter
    EX_squared <- EX * EX

    sumEX <- sumEX + EX
    sumEX_squared <- sumEX_squared + EX_squared
}

EEX <- sumEX / nreps
EEX_squared <- sumEX_squared / nreps
EEXsquared <- EEX * EEX

VarEX <-  EEX_squared - EEXsquared

print(VarEX)