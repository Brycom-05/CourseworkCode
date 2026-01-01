library(ggplot2)

data <- read.table("C:/Users/bryan/Downloads/ECS 132/out-dnc-corecipient.txt", header = TRUE, sep = "\t")
subset <- data[data$ID1 < data$ID2,]

all_nodes <- c(subset$ID1, subset$ID2)
deg_table <- table(all_nodes)
degrees <- as.integer(deg_table)

mi_table <- as.data.frame(table(degrees), stringAsFactors = FALSE)
colnames(mi_table) <- c("degree", "count")
mi_table$degree <- as.integer(as.character(mi_table$degree))
mi_table$count <- as.integer(mi_table$count)

# remove degree 0 if present (shouldn't be in this construction)
mi_table <- mi_table[mi_table$degree > 0, ]

# Create log columns for plotting and fitting (only keep counts > 0)
mi_table$log_degree <- log(mi_table$degree)
mi_table$log_count  <- log(mi_table$count)

# Fit linear model: log(m_i) ~ log(i)
fit <- lm(log_count ~ log_degree, data = mi_table)
coefs <- coef(fit)
intercept <- coefs["(Intercept)"]
slope     <- coefs["log_degree"]
gamma_hat <- -slope   # for pmf ~ C * i^{-gamma}, slope = -gamma

# Print gamma estimate
cat(sprintf("Estimated slope = %.5f\n", slope))
cat(sprintf("Estimated intercept = %.5f\n", intercept))
cat(sprintf("Estimated gamma = %.5f\n", gamma_hat))

# Plot log(m_i) vs log(i) with fitted line using ggplot2
p <- ggplot(mi_table, aes(x = log_degree, y = log_count)) +
  geom_point(size = 2, alpha = 0.7) +
  # add fitted line using the coefficients from lm()
  geom_abline(intercept = intercept, slope = slope, linetype = "dashed", linewidth = 1) +
  labs(
    x = "log(i)",
    y = "log(m_i)",
    title = "Plot of degree count: log(m_i) vs log(i)",
    subtitle = sprintf("Fitted line: intercept = %.3f, slope = %.3f   => gamma_hat = %.3f", intercept, slope, gamma_hat)
  ) +
  theme_minimal()

print(p)