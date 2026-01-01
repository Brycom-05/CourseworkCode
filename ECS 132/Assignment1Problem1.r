sim <- function(spin1, total = 18, nreps = 10000) {
    totalspins <- 0
    count <- 0
    
    for (i in 1:nreps) {
        spin2 <- sample(0:16, 1)
        spin3 <- sample(0:16, 1)

        sum <- spin1 + spin2 + spin3

        if (sum == 18) {
            count <- count + 1
        }
        totalspins <- totalspins + 1
    }

    return (count/totalspins)
}

print(sim(5))
print(sim(8))