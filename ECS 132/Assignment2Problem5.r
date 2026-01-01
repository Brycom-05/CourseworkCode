N <- 20000
p <- 0.06
pi <- 0.1
nreps <- 200

O_list <- numeric(nreps)
Ohat_list <- numeric(nreps)

for (i in 1:nreps) {
    O <- rbinom(1, N, p)
    Os <- rbinom(1, O, pi)
    Ohat <- Os/pi

    O_list[i] <- O
    Ohat_list[i] <- Ohat
}

O_average <- mean(O_list)
O_var <- var(O_list)
Ohat_average <- mean(Ohat_list)
Ohat_var <- var(Ohat_list)

print(O_average)
print(O_var)
print(Ohat_average)
print(Ohat_var)