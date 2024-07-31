## This script was used to plot Fst values for sections of chromosomes for report figures 


# Load package if required
install.packages("tidyverse")
library(tidyverse)

# Read in the Fst results file
fst <- read_tsv("~/OneDrive/Adaptation_to polyploidy_project/Genome_scans/DIPTET_WS1_MS1_BPM.txt")


# Plot a specific region on a chromosome
# Create a subset of the Fst data based on known position of hit (6597498)
start_coord <- 6400000  #6597399 6500000 6680000
end_coord <- 6700000
subset_fst <- subset(fst, scaff == "scaffold_3" & start >= start_coord & start <= end_coord)


# Plot the Fst values 
fst_plot <- ggplot(subset_fst, aes(x = start, y = FstWC)) +
  geom_point() +
  annotate("segment", x=6515213, y=0.65, xend =6519655, yend=0.65, color="red", size=1 ) +
  annotate("segment",x=6597399, y=0.75, xend =6598834, yend=0.75, color="red", size=1) +
  annotate("segment",x=6591467.5, y=0.75, xend =6595360.5, yend=0.75, color="red", size=1) +
  annotate("rect", xmin=6515213, xmax=6519655, ymin= 0, ymax=0.7, alpha=0.2, fill="grey") +
  annotate("rect", xmin=6597399, xmax=6598834, ymin= 0, ymax=0.75, alpha=0.2, fill="grey") +
  annotate("rect", xmin=6591467.5, xmax=6595360.5, ymin= 0, ymax=0.75, alpha=0.2, fill="grey") +
  theme_classic() +
  labs(
    #title = "Fst plot showing section ",
    x = "Position on Scaffold 3",
    y = "FstWC"
  ) +
  theme(
    plot.title = element_text(hjust = 0.5) ) 


print(fst_plot)

