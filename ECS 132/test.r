sim <- function(total, throw1 = 3, nreps = 10000) {
    count1 <- 0
    count2 <- 0

    for (i in 1:nreps) {
        throw2 = sample(1:6, 1)
        throw3 = sample(1:6, 1)
        throw4 = sample(1:6, 1)

        sum <- throw1 + throw2 + throw3 + throw4

        if (sum > total & throw3 < throw4) {
            count1 <- count1 + 1
        }
        if (throw3 < throw4) {
            count2 <- count2 + 1
        }
    }

    return (count1/count2)
}

print(sim(9))