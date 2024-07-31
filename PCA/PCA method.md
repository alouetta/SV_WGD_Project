# PCA instructions

The script below takes our SNP VCF file, creates a covariance matrix, performs PCA with the R function prcomp and extracts the first 2 axes for plotting in R. The script is taken from https://github.com/thamala/polySV/blob/main/est_cov_pca.r (Tuomas Hämälä, April 2024).

**Script == est_cov_pca.R**

**Package used == R version 4.4**

**Input == wgd_arenosa.fourfold_filtered_pruned.vcf**

**Output == PCA_wgd_arenosa_all.pdf**

PCA plot PCA_wgd_arenosa_all.pdf is very busy and has too many labels so create a plot without labels PCA_wgd_arenosa_nolabels.pdf by deleting the line (geom_text_repel(aes(label=id), size=4, max.overlaps = 100, force=20, color="black")+) from the script and then add 1 label on for each population manually using a zoomed in PCA_wgd_arenosa_all.pdf as a guide.
