install.packages("BiocManager")
BiocManager::install("rhdf5")
library(rhdf5);
library(ggplot2);
library(dplyr);
library(tidyr);
library(car);
library(ggpubr);
library(nortest);
library(dunn.test);
library(rstatix);
library(emmeans) ;

h5_test <- "./Data/CHO_Exp1_small14.h5"
h5ls(h5_test)

h5_exp1 <- "./Data/0702_lg.h5"
h5ls(h5_exp1)
exp1_small_cdf_data <- h5read(h5_exp1, "/Dataset_1/CDFOfJumps")
exp1_small_ssd_data <- h5read(h5_exp1, "/Dataset_1/SortedSquaredDisp")
exp1_small_ssd_df <- as.vector(exp1_small_ssd_data)
exp1_large_cdf_data <- h5read(h5_exp1, "/Dataset_2/CDFOfJumps")
exp1_large_ssd_data <- h5read(h5_exp1, "/Dataset_2/SortedSquaredDisp")
exp1_large_ssd_df <- as.vector(exp1_large_ssd_data)

h5_exp2 <- "./Data/0708_2.h5"
exp2_small_cdf_data <- h5read(h5_exp2, "/Dataset_1/CDFOfJumps")
exp2_small_ssd_data <- h5read(h5_exp2, "/Dataset_1/SortedSquaredDisp")
exp2_small_ssd_df <- as.vector(exp2_small_ssd_data)
exp2_large_cdf_data <- h5read(h5_exp2, "/Dataset_2/CDFOfJumps")
exp2_large_ssd_data <- h5read(h5_exp2, "/Dataset_2/SortedSquaredDisp")
exp2_large_ssd_df <- as.vector(exp2_large_ssd_data)

h5_exp3 <- "./Data/0711_2.h5"
exp3_small_cdf_data <- h5read(h5_exp3, "/Dataset_1/CDFOfJumps")
exp3_small_ssd_data <- h5read(h5_exp3, "/Dataset_1/SortedSquaredDisp")
exp3_small_ssd_df <- as.vector(exp3_small_ssd_data)
exp3_large_cdf_data <- h5read(h5_exp3, "/Dataset_2/CDFOfJumps")
exp3_large_ssd_data <- h5read(h5_exp3, "/Dataset_2/SortedSquaredDisp")
exp3_large_ssd_df <- as.vector(exp3_large_ssd_data)


exp1_S <- data.frame(
  CDFOfJumps = as.vector(exp1_small_cdf_data),
  SortedSquareDisps = as.vector(exp1_small_ssd_data),
  Experiment = "Experiment 1",
  Group = "Small",
  Log10SortedSquareDisps = log10(exp1_small_ssd_df)
)
exp1_L <- data.frame(
  CDFOfJumps = as.vector(exp1_large_cdf_data),
  SortedSquareDisps = as.vector(exp1_large_ssd_data),
  Experiment = "Experiment 1",
  Group = "Large",
  Log10SortedSquareDisps = log10(exp1_large_ssd_df)
)

exp2_S <- data.frame(
  CDFOfJumps = as.vector(exp2_small_cdf_data),
  SortedSquareDisps = as.vector(exp2_small_ssd_data),
  Experiment = "Experiment 2",
  Group = "Small",
  Log10SortedSquareDisps = log10(exp2_small_ssd_df)
)
exp2_L <- data.frame(
  CDFOfJumps = as.vector(exp2_large_cdf_data),
  SortedSquareDisps = as.vector(exp2_large_ssd_data),
  Experiment = "Experiment 2",
  Group = "Large",
  Log10SortedSquareDisps = log10(exp2_large_ssd_df)
)
exp3_S <- data.frame(
  CDFOfJumps = as.vector(exp3_small_cdf_data),
  SortedSquareDisps = as.vector(exp3_small_ssd_data),
  Experiment = "Experiment 3",
  Group = "Small",
  Log10SortedSquareDisps = log10(exp3_small_ssd_df)
)
exp3_L <- data.frame(
  CDFOfJumps = as.vector(exp3_large_cdf_data),
  SortedSquareDisps = as.vector(exp3_large_ssd_data),
  Experiment = "Experiment 3",
  Group = "Large",
  Log10SortedSquareDisps = log10(exp3_large_ssd_df)
)
# --- Combine Data into a Single Data Frame ---
experiments_df <- bind_rows(
  exp1_S,
  exp1_L,
  exp2_S,
  exp2_L,
  exp3_S,
  exp3_L
) %>%
  # Ensure 'Experiment' and 'Group' are factors
  mutate(
    Experiment = factor(Experiment, levels = paste("Experiment", 1:3)),
    Group = factor(Group, levels = c("Small", "Large"))
  )

# Check restructured data
str(experiments_df)
head(experiments_df)

# Histograms
hist_plot <- ggplot(experiments_df, aes(x = SortedSquareDisps, fill = Group)) +
  geom_histogram(binwidth = 0.2, position = "identity", alpha = 0.6) +
  facet_wrap(~Experiment, scales = "free_y", ncol = 1) + # Each experiment in its own row
  labs(
    title = "Histograms of r^2 by Experiment and Group",
    x = "r^2 (microns^2/s)",
    y = "Frequency"
  ) +
  theme_minimal() +
  scale_fill_manual(values = c("Small" = "darkblue", "Large" = "lightblue"))

print(hist_plot)

# Log transformed Density plot
density_plot <- ggplot(experiments_df, aes(x = Log10SortedSquareDisps, color = Group, fill = Group)) +
  geom_density(alpha = 0.5) +
  facet_wrap(~Experiment, scales = "free_y", ncol = 1) + # Each experiment in its own row
  labs(
    title = "Density Plots of r^2 by Experiment and Group",
    x = "Log10 r^2 (microns^2/s)",
    y = "Density"
  ) +
  theme_minimal() +
  scale_color_manual(values = c("Small" = "darkblue", "Large" = "lightblue")) +
  scale_fill_manual(values = c("Small" = "darkblue", "Large" = "lightblue"))

print(density_plot)

# QQ Plots
qq_plot <- ggplot(experiments_df, aes(sample = SortedSquareDisps)) +
  stat_qq() +
  stat_qq_line(color = "red", linetype = "dashed") +
  # Facet by both Experiment and Group for all 6 combinations
  facet_grid(Experiment ~ Group, scales = "free") + # Rows for Experiment, Columns for Group
  labs(
    title = "Q-Q Plots of CDFOfJumps by Experiment and Group",
    x = "Theoretical Quantiles",
    y = "Sample Quantiles"
  ) +
  theme_minimal()

print(qq_plot)

# QQ plot of log-transformed
qq_plotLT <- ggplot(experiments_df, aes(sample = Log10SortedSquareDisps)) +
  stat_qq() +
  stat_qq_line(color = "red", linetype = "dashed") +
  # Facet by both Experiment and Group for all 6 combinations
  facet_grid(Experiment ~ Group, scales = "free") + # Rows for Experiment, Columns for Group
  labs(
    title = "Q-Q Plots of Log-transformed r^2, by Experiment and Group",
    x = "Theoretical Quantiles",
    y = "Sample Quantiles"
  ) +
  theme_minimal()

print(qq_plotLT)


# Violin plots
violin_plot <- ggplot(experiments_df, aes(x = Group, y = Log10SortedSquareDisps, fill = Group)) +
  geom_violin(trim = FALSE, alpha = 0.7) +
  geom_boxplot(width = 0.1, fill = "white", color = "black", alpha = 0.7) +
  facet_wrap(~Experiment, scales = "free_y", ncol = 3) + # Layout 3 experiments side-by-side
  labs(
    title = "Violin Plots of SortedSquareDisps by Experiment and Group",
    x = "Group Size",
    y = "r^2 (microns^2/s)"
  ) +
  theme_minimal() +
  scale_fill_manual(values = c("Small" = "darkblue", "Large" = "lightblue")) +
  theme(legend.position = "none") # Hide legend as group is on x-axis

print(violin_plot)


# CDF plot
CDF_plot <- ggplot(experiments_df, aes(x = SortedSquareDisps, y = CDFOfJumps, color = Group, shape = Experiment)) +
  geom_line(linewidth = 0.8) + # Use geom_line for line plot, increase linewidth for better visibility
  labs(
    title = "CDF of r^2",
    x = "r^2 (microns^2/s)",
    y = "CDF",
    color = "Data Source" # Legend title
  ) +
  theme_minimal() +
  scale_x_log10()
print(CDF_plot)
# CDF plot of log10 transformed
CDF_plotLog <- ggplot(experiments_df, aes(x = Log10SortedSquareDisps, y = CDFOfJumps, color = Group, shape = Experiment)) +
  geom_line(linewidth = 0.8) + # Use geom_line for line plot, increase linewidth for better visibility
  labs(
    title = "CDF of log10(r^2)",
    x = "Log10 r^2 (microns^2/s)",
    y = "CDF",
    color = "Data Source" 
  ) +
  theme_minimal() 

  print(CDF_plotLog)

# normality tests

# Function to safely perform Shapiro-Wilk on a sample
shapiro_sample_test <- function(data_vector) {
  if (length(data_vector) > 5000) {
    data_vector <- sample(data_vector, 5000)
  }
  shapiro.test(data_vector)
}

normality_resultsRaw <- experiments_df %>%
  group_by(Experiment, Group) %>%
  summarize(
    N = n(),
    Shapiro_W = tryCatch(shapiro_sample_test(SortedSquareDisps)$statistic, error = function(e) NA),
    Shapiro_p = tryCatch(shapiro_sample_test(SortedSquareDisps)$p.value, error = function(e) NA),
    Lilliefors_p = tryCatch(lillie.test(SortedSquareDisps)$p.value, error = function(e) NA),
    AD_p = tryCatch(ad.test(SortedSquareDisps)$p.value, error = function(e) NA),
    .groups = "drop"
  )

print(normality_resultsRaw)

normality_resultsLog <- experiments_df %>%
  group_by(Experiment, Group) %>%
  summarize(
    N = n(),
    Shapiro_W = tryCatch(shapiro_sample_test(Log10SortedSquareDisps)$statistic, error = function(e) NA),
    Shapiro_p = tryCatch(shapiro_sample_test(Log10SortedSquareDisps)$p.value, error = function(e) NA),
    Lilliefors_p = tryCatch(lillie.test(Log10SortedSquareDisps)$p.value, error = function(e) NA),
    AD_p = tryCatch(ad.test(Log10SortedSquareDisps)$p.value, error = function(e) NA),
    .groups = "drop"
  )
print(normality_resultsLog)
# KW

# 1. Create a combined group variable
experiments_df <- experiments_df %>%
  mutate(CombinedGroup = paste(Experiment, Group, sep = " - ")) %>%
  mutate(CombinedGroup = factor(CombinedGroup, levels = unique(CombinedGroup)))

# 2. Perform Kruskal-Wallis test
# The formula is 'dependent_variable ~ independent_variable'
kruskal_result <- kruskal.test(SortedSquareDisps ~ CombinedGroup, data = experiments_df)

print("Kruskal-Wallis Test Result:")
print(kruskal_result)

# 3. Post-hoc test (if Kruskal-Wallis is significant, which it likely will be with large N)
# Kruskal-Wallis tells you *if* there's a difference, but not *where*.
# Dunn's test is a common post-hoc for Kruskal-Wallis.

# This might take a moment due to the large number of comparisons and sample size
# Note: Dunn's test expects the groups to be numerically coded or converted to factors
dunn_result <- dunn.test(
  x = experiments_df$SortedSquareDisps,
  g = experiments_df$CombinedGroup,
  method = "bonferroni", # Or "holm", "hochberg", "sidak", "fdr", etc.
  altp = TRUE # Show adjusted p-values
)


print("\nDunn's Post-hoc Test Result (Bonferroni adjusted p-values):")
print(dunn_result)

# Create the bar plot of medians
median_bar_plot <- experiments_df %>%
  group_by(Experiment, Group, CombinedGroup) %>%
  summarise(
    Median_SortedSquaredDisps = median(SortedSquareDisps),
    IQR_lower = quantile(SortedSquareDisps, 0.25),
    IQR_upper = quantile(SortedSquareDisps, 0.75),
    .groups = "drop"
  ) %>%
  ggplot(aes(x = CombinedGroup, y = Median_SortedSquaredDisps, fill = Group)) +
  geom_boxplot(stat = "identity", position = position_dodge(width = 0.9), color = "black") +
  # Add error bars for IQR
  geom_errorbar(aes(ymin = IQR_lower, ymax = IQR_upper),
    width = 0.2, position = position_dodge(width = 0.9)
  ) +
  labs(
    title = "Median r^2 by Experiment and Group",
    x = "Experiment and Group",
    y = "Median r^2 Value",
    fill = "Group Size"
  ) +
  theme_minimal() +
  scale_fill_manual(values = c("Small" = "darkblue", "Large" = "lightblue")) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1), # Rotate x labels for readability
    plot.title = element_text(hjust = 0.5) # Center plot title
  )

print(median_bar_plot)
# Create the boxplot
boxplot_plot <- ggplot(experiments_df, aes(x = CombinedGroup, y = SortedSquareDisps, fill = Group)) +
  geom_boxplot(shape = 1) + # Add outlier.shape to clearly see individual outliers
  labs(
    title = "Median r^2 by Experiment and Group",
    x = "Experiment and Group",
    y = "Median r^2 Value",
    fill = "Group Size"
  ) +
  theme_minimal() +
  scale_fill_manual(values = c("Small" = "darkblue", "Large" = "lightblue")) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1), # Rotate x labels for readability
    plot.title = element_text(hjust = 0.5) # Center plot title
  ) +
  scale_y_log10()

print(boxplot_plot)

# (Keep all the previous data setup and library loading)

# --- Downsample the data for plotting only ---
# Choose a reasonable sample size per group, e.g., 5000 or 10000 points per group.
# Adjust 'sample_size_per_group' based on your total N and desired plot clarity.
sample_size_per_group <- 10000 # Example: Sample 10,000 points from each group

sampled_data_for_plot <- experiments_df %>%
  group_by(Experiment, Group) %>%
  sample_n(min(n(), sample_size_per_group), replace = FALSE) %>% # Sample without replacement
  ungroup()

# Create the boxplot with SAMPLED data points (jittered)
boxplot_with_sampled_points_plot <- ggplot(experiments_df, aes(x = CombinedGroup, y = SortedSquareDisps, fill = Group)) +
  # Use the sampled_data_for_plot for geom_jitter
  geom_jitter(
    data = sampled_data_for_plot, # IMPORTANT: Specify the data for *this* geom
    aes(color = Group),
    width = 0.2,
    alpha = 0.3, # Alpha can be higher since fewer points
    size = 0.8
  ) +
  geom_boxplot(
    outlier.shape = NA,
    fill = NA,
    color = "black",
    width = 0.3
  ) +
  labs(
    title = paste("Boxplot of r^2 (N=", sample_size_per_group, "per group)"),
    x = "Experiment and Group",
    y = "r^2 (microns^2/s)",
    fill = "Group Size",
    color = "Group Size"
  ) +
  theme_minimal() +
  scale_fill_manual(values = c("Small" = "darkblue", "Large" = "lightblue")) +
  scale_color_manual(values = c("Small" = "darkblue", "Large" = "lightblue")) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),
    plot.title = element_text(hjust = 0.5)
  ) +
  ylim(0, 150) +
  stat_compare_means(
    method = "kruskal.test",
    label.x.npc = "left", # Position the label (normalized parent coordinates)
    label.y.npc = "top"
  ) # Adjust as needed to place it correctly


print(boxplot_with_sampled_points_plot)

# # 1. Perform Dunn's test using rstatix::dunn_test
# # This is more convenient for ggpubr integration than the dunn.test package output.
dunn_results_formatted <- experiments_df %>%
  dunn_test(SortedSquareDisps ~ CombinedGroup, p.adjust.method = "bonferroni") %>%
  add_xy_position(x = "CombinedGroup") # Adds x and y coordinates for plotting

# print("Formatted Dunn Test Results for Plotting:")
# print(dunn_results_formatted)

# # Now, plot with these results.
# # IMPORTANT: With 6 groups, there are (6 * 5) / 2 = 15 possible pairwise comparisons.
# # Plotting all 15 on one graph will be extremely cluttered.
# # You will likely need to select specific comparisons or group them.

# # Example: Plotting ALL significant pairwise comparisons
# # This can still be very busy.

# boxplot_pairwise_dunn_pvalues <- ggplot(all_data_combined, aes(x = CombinedGroup, y = CDFOfJumps, fill = Group)) +
#   geom_jitter(aes(color = Group),
#               width = 0.2,
#               alpha = 0.05,
#               size = 0.5) +
#   geom_boxplot(outlier.shape = NA,
#                fill = NA,
#                color = "black",
#                width = 0.3) +
#   labs(
#     title = "CDFOfJumps Distribution with Pairwise Dunn Test P-values",
#     x = "Experiment and Group",
#     y = "CDFOfJumps Value",
#     fill = "Group Size",
#     color = "Group Size"
#   ) +
#   theme_minimal() +
#   scale_fill_manual(values = c("Small" = "darkblue", "Large" = "lightblue")) +
#   scale_color_manual(values = c("Small" = "darkblue", "Large" = "lightblue")) +
#   theme(
#     axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),
#     plot.title = element_text(hjust = 0.5)
#   ) +
#   # Add pairwise p-values using stat_pvalue_manual
#   stat_pvalue_manual(
#     dunn_results_formatted,
#     label = "p.adj.signif", # Use significance symbols (e.g., *, **, ns)
#     hide.ns = TRUE,        # Hide non-significant comparisons for cleaner plot
#     tip.length = 0.01,     # Length of the tips of the brackets
#     bracket.nudge.y = 0.05, # Nudge brackets up a bit
#     step.increase = 0.08   # Increase vertical space between brackets
#   ) +
#   # Add more space above the plot for the labels
#   scale_y_continuous(expand = expansion(mult = c(0.05, 0.15))) # Adjust top expansion as needed

# print(boxplot_pairwise_dunn_pvalues)