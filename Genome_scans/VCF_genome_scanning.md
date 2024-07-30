### Instructions for Genome scan of Structural Variant VCF data

## Introduction

This document outlines the steps taken to identify structural variants that may be under selection in tetraploid Arabidopsis arenosa individuals. It uses the VCF that has been filtered using SV_50_data_preparation.md

# Methods


1) Index the SV VCF file

- load htslib module onto HPC: module load htslib-uoneasy/1.18-GCC-13.2.0

- tabix -p vcf my_filtered_WGD_SV50.vcf

2) Create text files of sample names

- Created a text file of the sample names of the diploids (dips.txt) and another of the sample names of the tetraploids (tets.txt) by copying and pasting from the excel file "WGD samples" in Data folder.

3) Use vcftools to perform Fst analysis

- load module: module load bcftools-uoneasy/1.18-GCC-13.2.0

- vcftools --gzvcf my_filtered_WGD_SV50.vcf --weir-fst-pop dips.txt --weir-fst-pop tets.txt --out WGD_WCarp_all_SV50_norm_rmdup.weir.fst


4) Perform search for genes

Script == gene_search_vcf_all_cols.R
Input data == 1)WGD_WCarp_all_SV50_norm_rmdup.weir.fst 
              2)Arabidopsis_arenosa_genome.annotation.simple.gtf

Output data == 1) Top20_WGD_WCarp_VCF_FstWC_results.xlsx
               2) Genes_within_5kb_top20hits_vcfdata.txt


5) Identify A.thaliana and A.Lyrata orthologs of genes
This script creates a list of the A.thaliana and A.lyrata orthologs for the A.arenosa genes identified using gene_search_vcf_all_cols.R for use in enrichment analyses such as STRING. It also creates an excel file showing the hit number (1-20), scaffold and position of each orthologue.
Script == find_orthologs_from_vcf_scan.R
Input data == i)Genes_within_5kb_top20hits_vcfdata.txt
              ii)A_arenosa__v__A_thaliana.tsv
              iii)A_arenosa__v__A_lyrata_NCBI.tsv
Output data == i)AT_gene_search_results_vcfdata.xlsx 
			   ii)AL_gene_search_results_vcfdata.xlsx
			   iii)Thaliana_orthos_top20_5kb_vcfdata.txt
			   iv)Lyrata_orthos_top20_5kb_vcfdata.txt










