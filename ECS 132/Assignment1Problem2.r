nreps <- 1000
q <- 0.8
p <- 0.4
collisions <- 0
count <- 0

for (i in 1:nreps) {
    numActive = 0
    numSend = 0

    for (j in 1:2) {
        if (runif(1) < q) {
            numActive = numActive + 1
        }
    }

    for (j in 1:numActive) {
        if (runif(1) < p) {
            numSend = numSend + 1
        }
    }

    if (numSend == 2) {
        X1 = 2
        collisions = collisions + 1
    }
    else {
        X1 = numActive - numSend
    }

    if (X1 == 0) {
        count = count + 1
    }
}

print(count/nreps)