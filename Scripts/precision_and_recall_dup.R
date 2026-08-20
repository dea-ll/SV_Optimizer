#!/usr/bin/env Rscript

# ============================================================
# HG002 duplications >50 bp
# Precision and recall across PE-SR callers
# ============================================================

# Load packages
library(ggplot2)
library(dplyr)
library(tidyr)

# ------------------------------------------------------------
# Input data
# ------------------------------------------------------------

results <- data.frame(
  Caller = c(
    "Delly",
    "Dysgu",
    "GRIDSS",
    "Manta",
    "Smoove",
    "SvABA",
    "whamg"
  ),

  Precision = c(
    0.081,
    0.130,
    0.231,
    0.512,
    0.167,
    0.454,
    0.453
  ),

  Recall = c(
    0.011,
    0.003,
    0.126,
    0.088,
    0.016,
    0.074,
    0.173
  )
)

# Keep caller order
results$Caller <- factor(
  results$Caller,
  levels = c(
    "Delly",
    "Dysgu",
    "GRIDSS",
    "Manta",
    "Smoove",
    "SvABA",
    "whamg"
  )
)

# ------------------------------------------------------------
# Convert to long format
# ------------------------------------------------------------

plot_data <- results %>%
  pivot_longer(
    cols = c(Precision, Recall),
    names_to = "Metric",
    values_to = "Value"
  )

# Order legend
plot_data$Metric <- factor(
  plot_data$Metric,
  levels = c("Recall", "Precision")
)

# ------------------------------------------------------------
# Plot
# ------------------------------------------------------------

p <- ggplot(
  plot_data,
  aes(
    x = Caller,
    y = Value,
    fill = Metric
  )
) +
  geom_col(
    position = position_dodge(width = 0.8),
    width = 0.7
  ) +

  # Add labels only for the most informative recall values
  geom_text(
    data = subset(
      plot_data,
      Metric == "Recall" & Caller %in% c("GRIDSS", "whamg")
    ),
    aes(
      label = sprintf("%.2f", Value),
      group = Metric
    ),
    position = position_dodge(width = 0.8),
    vjust = -0.4,
    size = 4
  ) +

  scale_y_continuous(
    limits = c(0, 0.60),
    breaks = seq(0, 0.60, 0.10),
    expand = expansion(mult = c(0, 0.02))
  ) +

  labs(
    title = "HG002 duplications >50 bp: low recall across PE-SR callers",
    x = NULL,
    y = "Metric value",
    fill = NULL
  ) +

  theme_minimal(base_size = 14) +

  theme(
    plot.title = element_text(
      face = "bold",
      size = 18,
      hjust = 0.5
    ),

    axis.title.y = element_text(
      size = 14
    ),

    axis.text.x = element_text(
      angle = 30,
      hjust = 1,
      size = 12
    ),

    axis.text.y = element_text(
      size = 11
    ),

    legend.position = "top",

    legend.text = element_text(
      size = 12
    ),

    panel.grid.major.x = element_blank(),

    panel.grid.minor = element_blank(),

    plot.margin = margin(
      t = 15,
      r = 15,
      b = 15,
      l = 15
    )
  )

# ------------------------------------------------------------
# Save figure
# ------------------------------------------------------------

output_dir <- "Figures"

dir.create(
  output_dir,
  showWarnings = FALSE,
  recursive = TRUE
)

ggsave(
  filename = file.path(
    output_dir,
    "HG002_DUP_precision_recall_PE_SR.png"
  ),
  plot = p,
  width = 11,
  height = 6,
  dpi = 300
)

ggsave(
  filename = file.path(
    output_dir,
    "HG002_DUP_precision_recall_PE_SR.pdf"
  ),
  plot = p,
  width = 11,
  height = 6
)

cat("Figure generated successfully.\n")
cat(
  "Output:",
  file.path(
    output_dir,
    "HG002_DUP_precision_recall_PE_SR.png"
  ),
  "\n"
)
