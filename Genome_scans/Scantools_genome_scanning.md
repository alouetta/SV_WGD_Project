### Instructions for Genome scan of ScanTools data

## Introduction

This document outlines the steps taken to identify structural variants that may be under selection in tetraploid Arabidopsis arenosa individuals. It uses the Scantools data provided by E.Curran.

# Methods
As the data already contains Fst results in a text file there is no need to prepare the data or calculate Fst as for the VCF data so scanning begins with the gene search.


1) Perform search for genes
This script takes a file of Scantools results, selects the top 20 highest FstWC results and using an annotated genome, identifies genes within 5kb of the position of the hits.
Script ==  gene_search_scantools_5kb.R
Input data == 1)DIPTET_WS1_MS1_BPM.txt
              2)Arabidopsis_arenosa_genome.annotation.simple.gtf

Output data == 1) Top20_scantools_FstWC_results.xlsx 
               2) Scantools_genes_within_5kb_top20hits.txt


2) Identify A.thaliana and A.Lyrata orthologs of genes
This script creates a list of the A.thaliana and A.lyrata orthologs for the A.arenosa genes identified using gene_search_scantools_5kb.R for use in enrichment analyses such as STRING. It also creates an excel file showing the hit number (1-20), scaffold and position of each orthologue.
Script == ortho_search_scantools_allcols.R
Input data == i)Scantools_genes_within_5kb_top20hits.txt
              ii)A_arenosa__v__A_thaliana.tsv
              iii)A_arenosa__v__A_lyrata_NCBI.tsv
Output data == i)Scantools_results_AT_gene_search.xlsx
			   ii)Scantools_results_AL_gene_search.xlsx
			   iii)Scantools_thaliana_orthos_top20_5kb.txt
			   iv)Scantools_lyrata_orthos_top20_5kb.txt










