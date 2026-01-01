sim <- function(nreps = 10000) {
    totalcards <- 0
    count210s <- 0
    count4spades <- 0

    for (i in 1:nreps) {
        num_of_10s <- 0
        num_of_spades <- 0

        #Hearts:    1-13,    1-9,    10: Jack, 11: Queen, 12: King, 13: Ace
        #Diamonds:  14-26,   14-22,  23: Jack, 24: Queen, 25: King, 26: Ace
        #Clubs:     27-39,   27-35,  36: Jack, 37: Queen, 38: King, 39: Ace
        #Spades:    40-52,   40-48,  49: Jack, 50: Queen, 51: King, 52: Ace

        draw <- sample(1:52, 5)

        for (j in draw) {
            if (j == 48 | j == 13 | j == 26 | j == 39) {
                num_of_10s <- num_of_10s + 1
            }
            if (j >= 40 & j <= 52) {
                num_of_spades <- num_of_spades + 1
            }
        }

        if (num_of_10s == 2) {
            count210s <- count210s + 1
        }
        if (num_of_spades == 4) {
            count4spades <- count4spades + 1
        }
        totalcards <- totalcards + 1
    }

    print(count210s/totalcards)
    print(count4spades/totalcards)
}

sim()