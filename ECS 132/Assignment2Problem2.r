nreps <- 10000
tosses <- 0

for (i in 1:nreps) {
    consHeads <- 0
    for (i in 1:7) {
        tosses <- tosses + 1
        if (runif(1) < 0.5) {
            consHeads <- consHeads + 1
        }
        else {
            consHeads <- 0
        }

        if (consHeads == 4) {
            break
        }
    }
}

print(tosses/nreps)