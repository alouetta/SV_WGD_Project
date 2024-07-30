## This script takes a .fst file of Fst results, selects the top 20 highest results and using an annotated genome, identifies
## genes within 5kb of the position of the hits.
## This script uses code from Speciation & Population Genomics: a how-to-guide (https://speciationgenomics.github.io/candidate_genes/)
## Own code added to include a for loop to automate multiple scanning on one script

library(writexl)
library(tidyverse)


# read in the SV scan data
scan_data <- read_tsv("~/Library/CloudStorage/OneDrive-Personal/Adaptation_to polyploidy_project/Genome_scans/WGD_WCarp_all_SV50_norm_rmdup.weir.fst")
# change column header
names(scan_data)[names(scan_data) == "WEIR_AND_COCKERHAM_FST"] <-"FST"

# Read in the annotated A.arenosa genome file
ref_data <- read_tsv("~/Library/CloudStorage/OneDrive-Personal/Adaptation_to polyploidy_project/Genome_scans/References/Arabidopsis_arenosa_genome.annotation.simple.gtf")
head(ref_data)

# Add column names
colnames(ref_data) <- c("scaffold", "start_pos", "end_pos", "dot", "strand", "score", "annotation")

# Make a gene mid point variable
ref_data <- ref_data %>% mutate(mid = start_pos + (end_pos-start_pos)/2)
head(ref_data)

# Identify the 20 highest peaks of selection
hits <- scan_data %>% arrange(desc(FST)) %>% top_n(20)

# Print the top hits to a file
write_xlsx(hits, "Top20_WGD_WCarp_VCF_FstWC_results.xlsx")


# find the nearest genes to the top 20 hits
hit_position <-hits$POS[1:20]
hit_scaffold <- hits$CHROM[1:20]
# Initialize a vector to store all annotations
all_annotations <- character()
all_positions <- character()
all_scaffolds <- character()
all_hit_numbers <- integer()

# Function to find annotations for each hit position
get_annotations <- function(x, scaffold, hit_number) {
  # Find hits closest to genes within 5 Kb of x
  gene_hits <- ref_data %>%
    mutate(hit_dist = abs(mid - x)) %>%
    arrange(hit_dist) %>%
    filter(hit_dist < 5000)
  
  # Extract annotations  
  annotations <- gene_hits$annotation
  positions <- gene_hits$mid
  
  if (length(annotations) > 0) {
    for (i in seq_along(annotations)) {
      all_annotations <<- c(all_annotations, annotations[i])
      all_positions <<- c(all_positions, positions[i])
      all_scaffolds <<- c(all_scaffolds, scaffold)
      all_hit_numbers <<- c(all_hit_numbers, hit_number)
    }
  }
}
  
# Apply get_annotations function to each hit position
for (i in seq_along(hit_position)) {
  get_annotations(hit_position[i], hit_scaffold[i], i)
}

# Create a data frame with all details
annotations_df <- data.frame(
  scaffold = all_scaffolds,
  hit_number = all_hit_numbers,
  annotation = all_annotations,
  position = all_positions,
  stringsAsFactors = FALSE
)

# Write all annotations to a single file
write.table(annotations_df, file = "Genes_within_5kb_top20hits_vcfdata.txt",sep = "\t", row.names = FALSE, col.names = TRUE, quote = FALSE)
