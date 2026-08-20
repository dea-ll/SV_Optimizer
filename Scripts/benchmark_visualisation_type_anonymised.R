#!/usr/bin/env Rscript

# ============================================================
# Simple benchmark visualisation
# This script groups the main steps I used for the benchmark.
# Paths are intentionally generic so that no internal path is shared.
# ============================================================

library(ggplot2)
library(dplyr)
library(tidyr)
library(jsonlite)

# ------------------------------------------------------------
# 1. Paths to adapt
# ------------------------------------------------------------

# Folder containing the Truvari summary.json files
results_dir <- "PATH_TO_TRUVARI_RESULTS"

# Folder where the figures will be saved
output_dir <- "Figures"

dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

# ------------------------------------------------------------
# 2. Read one Truvari summary.json file
# ------------------------------------------------------------

# Small helper because the TP field can have slightly different names
get_value <- function(x, names) {
  for (name in names) {
    if (!is.null(x[[name]])) {
      return(as.numeric(x[[name]]))
    }
  }
  return(NA_real_)
}

read_summary <- function(json_file) {

  # In my benchmark, the folder structure contained:
  # ... / SV_class / Caller / config_xxx / summary.json
  path_parts <- strsplit(json_file, "/")[[1]]
  n <- length(path_parts)

  sv_class <- path_parts[n - 3]
  caller   <- path_parts[n - 2]
  config   <- gsub("^config_?", "", path_parts[n - 1])

  x <- fromJSON(json_file)

  data.frame(
    SV_class = sv_class,
    Caller = caller,
    Config = config,
    TP = get_value(x, c("TP-comp", "TP_comp", "TP")),
    FP = get_value(x, c("FP")),
    FN = get_value(x, c("FN")),
    Precision = get_value(x, c("precision")),
    Recall = get_value(x, c("recall")),
    F1 = get_value(x, c("f1"))
  )
}

# ------------------------------------------------------------
# 3. Read all benchmark results
# ------------------------------------------------------------

json_files <- list.files(
  results_dir,
  pattern = "summary.json",
  recursive = TRUE,
  full.names = TRUE
)

if (length(json_files) == 0) {
  stop("No summary.json file found. Check results_dir.")
}

results_list <- lapply(json_files, function(f) {
  tryCatch(
    read_summary(f),
    error = function(e) NULL
  )
})

benchmark <- bind_rows(results_list)

# ------------------------------------------------------------
# 4. Select the results I want to compare
# ------------------------------------------------------------

# Read-depth callers used during the benchmark
rd_callers <- c("CNVkit", "CNVnator", "CNVpytor", "Canvas")

# Example:
# Keep PE/SR callers and the default Truvari configuration.
#
# To analyse RD callers instead, replace:
#   !Caller %in% rd_callers
# by:
#   Caller %in% rd_callers
#
# The SV classes can also be changed depending on the analysis.

plot_data <- benchmark %>%
  filter(Config == "truvari_default") %>%
  filter(!Caller %in% rd_callers) %>%
  filter(SV_class %in% c("DEL_50to10kb", "DEL_gt10kb", "DUP_all")) %>%
  distinct(SV_class, Caller, .keep_all = TRUE)

# ------------------------------------------------------------
# 5. Precision and recall
# ------------------------------------------------------------

precision_recall <- plot_data %>%
  select(SV_class, Caller, Precision, Recall) %>%
  pivot_longer(
    cols = c(Precision, Recall),
    names_to = "Metric",
    values_to = "Value"
  )

p1 <- ggplot(
  precision_recall,
  aes(x = Caller, y = Value, fill = Metric)
) +
  geom_col(position = "dodge") +
  facet_wrap(~ SV_class) +
  ylim(0, 1) +
  labs(
    title = "Precision and recall by SV caller",
    x = NULL,
    y = "Value"
  ) +
  theme_bw() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

ggsave(
  file.path(output_dir, "precision_recall.png"),
  p1,
  width = 10,
  height = 6,
  dpi = 300
)

# ------------------------------------------------------------
# 6. TP / FP / FN
# ------------------------------------------------------------

counts <- plot_data %>%
  select(SV_class, Caller, TP, FP, FN) %>%
  pivot_longer(
    cols = c(TP, FP, FN),
    names_to = "Category",
    values_to = "Count"
  )

p2 <- ggplot(
  counts,
  aes(x = Caller, y = Count, fill = Category)
) +
  geom_col(position = "dodge") +
  facet_wrap(~ SV_class, scales = "free_y") +
  labs(
    title = "True positives, false positives and false negatives",
    x = NULL,
    y = "Number of variants"
  ) +
  theme_bw() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

ggsave(
  file.path(output_dir, "TP_FP_FN.png"),
  p2,
  width = 10,
  height = 6,
  dpi = 300
)

# ------------------------------------------------------------
# 7. F1-score
# ------------------------------------------------------------

p3 <- ggplot(
  plot_data,
  aes(x = Caller, y = F1)
) +
  geom_col() +
  facet_wrap(~ SV_class) +
  ylim(0, 1) +
  labs(
    title = "F1-score by SV caller",
    x = NULL,
    y = "F1-score"
  ) +
  theme_bw() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

ggsave(
  file.path(output_dir, "F1_score.png"),
  p3,
  width = 10,
  height = 6,
  dpi = 300
)

cat("Benchmark figures created.\n")
