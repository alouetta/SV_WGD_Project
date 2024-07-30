## This script creates a list of the A.thaliana orthologs and A.lyrata orthologs for the A.arenosa genes identified in the genome scan for use in enrichment analyses such as STRING          
## This script uses code from Speciation & Population Genomics: a how-to-guide (https://speciationgenomics.github.io/candidate_genes/)
## Own code added to include a for loop to improve the script and code to create an excel file of with details for each ortholog.


# Load package if required
install.packages("tidyverse")
library(tidyverse)


# Read in the arenosa vs thaliana gene file
thaliana_reference <- read_tsv("~/Library/CloudStorage/OneDrive-Personal/Adaptation_to polyploidy_project/Genome_scans/References/A_arenosa__v__A_thaliana.tsv")
# Separate the genes in A_arenosa and A_thaliana columns in the gene file
thaliana_ortho_list <- thaliana_reference %>%
  mutate(A_arenosa = strsplit(A_arenosa, ","),
         A_thaliana = strsplit(A_thaliana, ","))

# Read in the lyrata reference file 
lyrata_reference <- read_tsv("~/Library/CloudStorage/OneDrive-Personal/Adaptation_to polyploidy_project/Genome_scans/References/A_arenosa__v__A_lyrata_NCBI.tsv")
# Separate the genes in A_arenosa and A_lyrata columns in the reference file
lyrata_ortho_list <- lyrata_reference %>%
  mutate(A_arenosa = strsplit(A_arenosa, ","),
         A_lyrata_NCBI = strsplit(A_lyrata_NCBI, ","))

# Read in the list of A.arenosa gene names created using gene_search_vcf_all_cols.R
arenosa_genes_df <- read_tsv("~/Library/CloudStorage/OneDrive-Personal/Adaptation_to polyploidy_project/Genome_scans/Gene_info/Genes_within_5kb_top20hits_vcfdata.txt")

# Extract gene names, scaffolds, positions, and hit numbers
arenosa_genes <- arenosa_genes_df$annotation
arenosa_scaffolds <- arenosa_genes_df$scaffold
arenosa_positions <- arenosa_genes_df$position
arenosa_hit_numbers <- arenosa_genes_df$hit_number

# Create a dataframe to store the thaliana results
AT_results <- data.frame(A_arenosa_gene = character(),
                         A_arenosa_scaffold = character(),
                         A_arenosa_position = numeric(),
                         A_arenosa_hit_number = numeric(),
                         A_thaliana_genes = character(),stringsAsFactors = FALSE)
# Create a dataframe to store the lyrata results
AL_results <- data.frame(A_arenosa_gene = character(),
                         A_arenosa_scaffold = character(),
                         A_arenosa_position = numeric(),
                         A_arenosa_hit_number = numeric(),
                         A_lyrata_genes = character(),stringsAsFactors = FALSE)


# Loop through the list of A.arenosa genes to get A.Thaliana orthologs
for (i in seq_along(arenosa_genes)) {
  gene <- arenosa_genes[i]
  scaffold <- arenosa_scaffolds[i]
  position <- arenosa_positions[i]
  hit_number <- arenosa_hit_numbers[i]
  
  gene_match <- thaliana_ortho_list %>%
    filter(sapply(A_arenosa, function(x) gene %in% x))
  
  if (nrow(gene_match) > 0) {

# Extract corresponding A.thaliana genes from the gene file and add to the results dataframe 
    for (j in 1:nrow(gene_match)) {
      thaliana_genes <- paste(gene_match$A_thaliana[[j]], collapse = ", ")
      AT_results <- rbind(AT_results, data.frame(A_arenosa_gene = gene, 
                                                 A_arenosa_scaffold = scaffold,
                                                 A_arenosa_position = position,
                                                 A_arenosa_hit_number = hit_number,
                                                 A_thaliana_genes = thaliana_genes, stringsAsFactors = FALSE))
    }
} else {
  AT_results <- rbind(AT_results, data.frame(A_arenosa_gene = gene,
                                             A_arenosa_scaffold = scaffold,
                                             A_arenosa_position = position,
                                             A_arenosa_hit_number = hit_number,
                                             A_thaliana_genes = "None found"))
}
}

## Repeat for the A.Lyrata orthologs ##
# Loop through the list of A.arenosa genes
for (i in seq_along(arenosa_genes)) {
  gene <- arenosa_genes[i]
  scaffold <- arenosa_scaffolds[i]
  position <- arenosa_positions[i]
  hit_number <- arenosa_hit_numbers[i]
  
  lyrata_match <- lyrata_ortho_list %>%
    filter(sapply(A_arenosa, function(x) gene %in% x))
  
  if (nrow(lyrata_match) > 0) {
    # Extract corresponding A. lyrata genes from the reference file and add to results dataframe
    for (j in 1:nrow(lyrata_match)) {
      lyrata_genes <- paste(lyrata_match$A_lyrata_NCBI[[j]], collapse = ", ")
      AL_results <- rbind(AL_results, data.frame(A_arenosa_gene = gene,
                                                 A_arenosa_scaffold = scaffold,
                                                 A_arenosa_position = position,
                                                 A_arenosa_hit_number = hit_number,
                                                 A_lyrata_genes = lyrata_genes, stringsAsFactors = FALSE))
    }
  } else {
    AL_results <- rbind(AL_results, data.frame(A_arenosa_gene = gene,
                                               A_arenosa_scaffold = scaffold,
                                               A_arenosa_position = position,
                                               A_arenosa_hit_number = hit_number,
                                               A_lyrata_genes = "None found"))
  }
}
## Create an excel file of the thaliana and lyrata search results and a separate text file with just
## gene names for functional searches after first separating out results and removing empty lines & name endings 

# Where a row has more than one ortholog, separate them out in different rows
AT_sepresults <- AT_results %>%
  separate_rows(A_thaliana_genes, sep = ",")
# Remove lines with None Found
row_contains_none_found <- function(row) {
  any(grepl("None found", row))
}
AT_orthologs_clean <- AT_sepresults[!apply(AT_sepresults, 1, row_contains_none_found), ]
# Remove ortholog name endings i.e. .1 
AT_orthologs_clean$A_thaliana_genes <- sub("\\.\\d{1,2}$", "", AT_orthologs_clean$A_thaliana_genes)
# Create an excel file of all the cleaned data
write_xlsx(AT_orthologs_clean, "AT_gene_search_results_vcfdata.xlsx")
# Create a text file of the thaliana gene names only for searches
AT_genes_only <- AT_orthologs_clean[, "A_thaliana_genes"]
write.table(AT_genes_only, "Thaliana_orthos_top20_5kb_vcfdata.txt", row.names = FALSE, col.names = FALSE, quote = FALSE)

# Lyrata ortholog results:
# Where a row has more than one ortholog, separate them out in different rows
AL_sepresults <- AL_results %>%
  separate_rows(A_lyrata_genes, sep = ",")
# Remove lines with None Found
AL_orthologs_clean <- AL_sepresults[!apply(AL_sepresults, 1, row_contains_none_found), ]
# Remove ortholog name endings i.e. .1 
AL_orthologs_clean$A_lyrata_genes <- sub("\\.\\d{1,2}$", "", AL_orthologs_clean$A_lyrata_genes)
# Create an excel file of the full cleaned data
write_xlsx(AL_orthologs_clean, "AL_gene_search_results_vcfdata.xlsx")
# Create a text file of the lyrata gene names only for searches
AL_genes_only <- AL_orthologs_clean[, "A_lyrata_genes"]
write.table(AL_genes_only, "Lyrata_orthos_top20_5kb_vcfdata.txt", row.names = FALSE, col.names = FALSE, quote = FALSE)