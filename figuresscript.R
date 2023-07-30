# Part A
library(readr)
library(dplyr)
library(ggplot2)
library(gridExtra)

raw <- read_csv("id114_2014.zip")

usable <- raw %>%
  drop_na(localminute, use)

cat("Number of Dropped Records:", nrow(raw) - nrow(usable), "\n")

# Part B
trim <- usable %>%
  separate(localminute, c("mo", "dy", "yr", "hr", "mi"), sep = "/| |:", convert = TRUE) %>%
  select(mo, dy, yr, hr, mi, use)

head(trim)

# Part C
group_by_hour <- trim %>%
  group_by(mo, dy, hr)

minutes <- group_by_hour %>%
  summarize(count = n())

mean_use <- group_by_hour %>%
  summarize(mean_use = mean(use), .groups = "drop") %>%
  mutate(mean_use = round(mean_use, 3))

fall_back <- minutes$count > 60

print(mean_use[fall_back, ])

mean_use <- mean_use[!fall_back, ]

# Calculate the median hourly usage for hours with 60 or fewer minutes of data
median_hourly_usage <- median(mean_use$mean_use, na.rm = TRUE)

# Print the result
cat("Median Hourly Usage:", median_hourly_usage, "\n")


write.csv(mean_use, file = "usage.csv", row.names = FALSE)


# Part D
cutoffs <- c(0.01, 0.05, 0.10, 0.25, 0.50, 0.75, 0.90, 0.95, 0.99)

pct <- quantile(mean_use$mean_use, cutoffs)

cat("Electricity Usage by Cutoffs:\n", pct, "\n")

load_duration <- mean_use %>%
  arrange(desc(mean_use)) %>%
  select(mean_use)

# Create a variable for the number of hours (1 to n)
load_duration$num_hours <- seq_len(nrow(load_duration))

# Plot the Load Duration Curve with geom_point()
plot_load_duration <- ggplot(load_duration, aes(x = num_hours, y = mean_use)) +
  geom_line() +
  labs(title = "Load Duration Curve for House 114",
       y = "kW (red=5th and 95th percentiles)",
       x = "Hours") +
  geom_hline(yintercept = pct[c(2, 8)], color = "red", linetype = "dashed", size = 1)+
  theme(panel.background = element_blank(),
        panel.grid = element_blank())

# Print the plot
print(plot_load_duration)


# Looking at the CF between the 5% and 95% percentile
cat("5th Percentile:", pct[2], "\n")
cat("95th Percentile:", pct[8], "\n")

# Interquartile Range
q25 <- quantile(mean_use$mean_use, 0.25)
q75 <- quantile(mean_use$mean_use, 0.75)
iqr <- q75 - q25
cat("The interquartile range in kW:", iqr, "\n")

# Part E
mo01 <- trim %>%
  filter(mo == 1) %>%
  select(use)

mo07 <- trim %>%
  filter(mo == 7) %>%
  select(use)

nbins <- 100

plot_usage <- function(data, title) {
  ggplot(data, aes(x = use)) +
    geom_histogram(bins = nbins) +
    geom_vline(xintercept = mean(data$use), color = "red") +
    geom_vline(xintercept = median(data$use), color = "green") +
    labs(title = title, x = "kW (red=mean, green=median)")
}

plot_mo01 <- plot_usage(mo01, "January")
plot_mo07 <- plot_usage(mo07, "July")

grid.arrange(plot_mo01, plot_mo07, nrow = 2, ncol = 1)
