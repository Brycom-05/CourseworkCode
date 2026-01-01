nreps <- 10000
sum <- 0

for (i in 1:nreps) {
    roll1 <- sample(1:8, 1)
    roll2 <- sample(1:8, 1)

    X <- roll1 + roll2

    sum <- sum + X
}

print(sum/nreps)