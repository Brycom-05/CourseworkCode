###############################
###  Single-roll PMF
###############################

count1 <- function() {
  out <- numeric(13)  # indices 1-13 correspond to sums 0-12
  for (i in 1:6) for (j in 1:6) out[i+j] <- out[i+j] + 1
  out[2:12]
}

p1_count <- count1()
p1 <- p1_count/36


###############################
###  PMF of sum of n rolls
###############################

pmf_sum <- function(n) {
  if (n == 1) return(p1)

  result_counts <- p1_count
  for (i in 2:n) {
    result_counts <- convolve(result_counts, rev(p1_count), type="open")
  }

  probs <- as.numeric(result_counts) / (36^n)
  probs
}


###############################
###  daccum(i,k) : P(X = i)
###  X = number of rolls to reach total >= k
###############################

daccum <- function(i, k) {
  i <- as.integer(i)

  sapply(i, function(m) {

    if (k > 12*m) return(0)      # can't reach k even with max outcome
    if (m == 1) {                # special case: first roll
      if (k <= 2) return(1)
      if (k > 12) return(0)
      start_index <- k - 1
      return(sum(p1[start_index:11]))
    }

    # distribution of S_{m-1}
    pm <- pmf_sum(m-1)

    # sums supported by S_{m-1}
    tvals <- (2*(m-1)):(12*(m-1))

    # probabilities for S_{m-1} = t
    index <- tvals - (2*(m-1)) + 1
    p_prev <- pm[index]

    # Only include cases where S_{m-1} < k
    valid <- tvals < k
    tvals <- tvals[valid]
    p_prev <- p_prev[valid]

    # required Y >= k - t
    need <- k - tvals

    # P(Y >= need)
    p_ge <- sapply(need, function(r) {
      if (r <= 2) return(1)
      if (r > 12) return(0)
      index <- r - 1
      sum(p1[index:11])
    })

    sum(p_prev * p_ge)
  })
}


###############################
###  paccum(i,k) : P(X ≤ i)
###############################

paccum <- function(i, k) {
  sapply(i, function(m) {
    nmin <- ceiling(k / 12)
    nmax <- floor((k-1)/2)
    if (m < nmin) return(0)
    if (m >= nmax+1) return(1)
    sum(daccum(nmin:m, k))
  })
}


###############################
###  qaccum(m,k) : smallest n with P(X ≤ n) ≥ m
###############################

qaccum <- function(m, k) {
  nmin <- ceiling(k / 12)
  nmax <- ceiling(k / 2)
  sapply(m, function(u) {
    sum <- 0
    for (j in nmin:nmax) {
      sum <- sum + daccum(j, k)
      if (sum >= u) return(j)
    }
    nmax
  })
}


###############################
###  raccum(nreps,k) : generate random variates
###############################

raccum <- function(nreps, k) {
  nmin <- ceiling(k / 12)
  nmax <- ceiling(k / 2)
  ns <- nmin:nmax
  pmf <- daccum(ns, k)
  pmf <- pmf / sum(pmf)
  sample(ns, nreps, replace=TRUE, prob=pmf)
}

