#!/usr/bin/env Rscript

# ============================================================
# Characteristics of the 40 manually supported candidate SVs
# ============================================================

library(ggplot2)

# ------------------------------------------------------------
# 1. Create the data table
# ------------------------------------------------------------

candidate_data <- data.frame(

  Category = c(
    "DEL <=10 kb",
    "DEL >10 kb",
    "DUP",

    "1 caller",
    "2 callers",
    "3 callers",

    "1/116",
    "2/116",
    "3-4/116"
  ),

  Number = c(
    25,
    4,
    11,

    15,
    23,
    2,

    21,
    9,
    10
  ),

  Group = c(
    "SV class",
    "SV class",
    "SV class",

    "Caller support",
    "Caller support",
    "Caller support",

    "Internal frequency",
    "Internal frequency",
    "Internal frequency"
  )
)

# ------------------------------------------------------------
# 2. Define category order
# ------------------------------------------------------------

candidate_data$Category <- factor(
  candidate_data$Category,
  levels = c(
    "DEL <=10 kb",
    "DEL >10 kb",
    "DUP",
    "1 caller",
    "2 callers",
    "3 callers",
    "1/116",
    "2/116",
    "3-4/116"
  )
)

candidate_data$Group <- factor(
  candidate_data$Group,
  levels = c(
    "SV class",
    "Caller support",
    "Internal frequency"
  )
)

# ------------------------------------------------------------
# 3. Create the graph
# ------------------------------------------------------------

p <- ggplot(
  candidate_data,
  aes(
    x = Category,
    y = Number
  )
) +

  geom_col(
    width = 0.7,
    fill = "steelblue"
  ) +

  geom_text(
    aes(label = Number),
    vjust = -0.4,
    size = 4
  ) +

  # This automatically creates the three panels
  facet_wrap(
    ~ Group,
    nrow = 1,
    scales = "free_x"
  ) +

  scale_y_continuous(
    limits = c(0, 30),
    breaks = seq(0, 30, 5)
  ) +

  labs(
    title = "40 technically supported candidate SVs after manual review",
    x = NULL,
    y = "Candidate SVs"
  ) +

  theme_minimal(base_size = 14) +

  theme(
    plot.title = element_text(
      face = "bold",
      size = 18,
      hjust = 0.5
    ),

    strip.text = element_text(
      face = "bold",
      size = 13
    ),

    axis.text.x = element_text(
      angle = 25,
      hjust = 1
    ),

    panel.grid.major.x = element_blank(),

    panel.grid.minor = element_blank()
  )

# ------------------------------------------------------------
# 4. Save
# ------------------------------------------------------------

dir.create(
  "Figures",
  showWarnings = FALSE
)

ggsave(
  "Figures/Candidate_SV_characteristics.png",
  plot = p,
  width = 12,
  height = 5,
  dpi = 300
)

ggsave(
  "Figures/Candidate_SV_characteristics.pdf",
  plot = p,
  width = 12,
  height = 5
)

cat("Candidate SV figure created successfully.\n")
