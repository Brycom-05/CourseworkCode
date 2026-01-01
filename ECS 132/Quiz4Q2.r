nreps <- 10000
winnings <- 0
for (i in 1:nreps) {
    consecutiveHeads <- 0
    for (i in 1:6) {
        winnings <- winnings + 1
        if (runif(1) < 0.5) {
            consecutiveHeads <- consecutiveHeads + 1
        }
        else {
            consecutiveHeads <- 0
        }

        if (consecutiveHeads == 3) {
            break
        }
    }
}

print(winnings/nreps)