nreps <- 1000
q <- 0.8
p <- 0.4
count <- 0
ans <- 0

for (i in 1:nreps) {
    numActive = 0
    numSend = 0
    collisions <- 0

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

    activeAfterE1 <- X1
    numSend = 0

    if (X1 < 2) {
        for (i in 1:(2-X1)) {
            if (runif(1) < q) {
                X1 = X1 + 1
            }
        }
    }

    for (j in 1:X1) {
        if (runif(1) < p) {
            numSend = numSend + 1
        }
    }

    if (numSend == 2) {
        X2 = 2
        collisions = collisions + 1
    }
    else {
        X2 = numActive - numSend
    }

    if (activeAfterE1 == 2) {
        count = count + 1
        if (X2 == 2) {
            ans = ans + 1
        }
    }
}

print(ans/count)