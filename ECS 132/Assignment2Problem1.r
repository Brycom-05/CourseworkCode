nreps <- 10000
sumL1 <- 0
sumL1_squared <- 0
sumL2 <- 0
sumL2_squared <- 0
sumL2minusL1 <- 0
sumL2minusL1_squared <- 0

for (i in 1:nreps) {
    B1 <- sample(0:2, 1, 0, c(0.5, 0.4, 0.1))
    L1 <- B1
    L1_squared <- L1 * L1
    sumL1 <- sumL1 + L1
    sumL1_squared <- sumL1_squared + L1_squared

    L2 <- L1
    if (L2 != 0) {
        for (i in 1:L2) {
            if (runif(1) < 0.2) {
                L2 <- L2 - 1
            }
        }
    }

    B2 <- sample(0:2, 1, 0, c(0.5, 0.4, 0.1))
    L2 <- L2 + B2
    L2_squared <- L2 * L2
    L2minusL1 <- L2 - L1
    L2minusL1_squared <- L2minusL1 * L2minusL1

    sumL2 <- sumL2 + L2
    sumL2_squared <- sumL2_squared + L2_squared
    sumL2minusL1 <- sumL2minusL1 + L2minusL1
    sumL2minusL1_squared <- sumL2minusL1_squared + L2minusL1_squared
}

ExL1 <- sumL1/nreps
ExL1squared <- ExL1 * ExL1
ExL1_squared <- sumL1_squared / nreps

ExL2 <- sumL2/nreps
ExL2squared <- ExL2 * ExL2
ExL2_squared <- sumL2_squared / nreps

ExL2minusL1 <- sumL2minusL1/nreps
ExL2minusL1squared <- ExL2minusL1 * ExL2minusL1
ExL2minusL1_squared <- sumL2minusL1_squared / nreps

VarL1 <- ExL1_squared - ExL1squared
VarL2 <- ExL2_squared - ExL2squared
VarL2minusL1 <- ExL2minusL1_squared - ExL2minusL1squared

print(VarL2minusL1)
print(VarL2 + VarL1)