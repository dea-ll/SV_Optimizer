#!/usr/bin/env Rscript

# ============================================================
# Internal HUG validation cohort
# Number of curated CNVs detected by each tool
# ============================================================

library(ggplot2)

# ------------------------------------------------------------
# 1. Create the data table
# ------------------------------------------------------------

results <- data.frame(
  Caller = c(
    "Delly",
    "Dysgu",
    "CNVpytor",
    "Manta",
    "Smoove",
    "Whamg",
    "CNVnator",
    "CNVkit",
    "Canvas",
    "Jasmine"
  ),

  Detected = c(
    59,
    58,
    51,
    33,
    40,
    40,
    51,
    30,
    29,
    64
  )
)

# Keep the caller order defined above
results$Caller <- factor(
  results$Caller,
  levels = results$Caller
)

# ------------------------------------------------------------
# 2. Create the graph
# ------------------------------------------------------------

p <- ggplot(
  results,
  aes(
    x = Caller,
    y = Detected
  )
) +

  geom_col(
    width = 0.75,
    fill = "steelblue"
  ) +

  # Add the number above each bar
  geom_text(
    aes(label = Detected),
    vjust = -0.4,
    size = 4
  ) +

  # Horizontal line corresponding to the 64 curated CNVs
  geom_hline(
    yintercept = 64,
    linetype = "dashed"
  ) +

  annotate(
    "text",
    x = 9,
    y = 65.5,
    label = "64 curated CNVs",
    size = 4
  ) +

  scale_y_continuous(
    limits = c(0, 70),
    breaks = seq(0, 70, 10)
  ) +

  labs(
    title = "Internal HUG validation cohort",
    x = NULL,
    y = "Detected CNVs (out of 64)"
  ) +

  theme_minimal(base_size = 14) +

  theme(
    plot.title = element_text(
      face = "bold",
      size = 18,
      hjust = 0.5
    ),

    axis.text.x = element_text(
      angle = 30,
      hjust = 1
    ),

    panel.grid.major.x = element_blank(),

    panel.grid.minor = element_blank()
  )

# ------------------------------------------------------------
# 3. Save the graph
# ------------------------------------------------------------

dir.create(
  "Figures",
  showWarnings = FALSE
)

ggsave(
  "Figures/Internal_HUG_validation.png",
  plot = p,
  width = 10,
  height = 6,
  dpi = 300
)

ggsave(
  "Figures/Internal_HUG_validation.pdf",
  plot = p,
  width = 10,
  height = 6
)

cat("Internal validation figure created successfully.\n")
