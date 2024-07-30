# SplitsTree Instructions

- To infer a phylogenetic network from a vcf file of our population data we first create a Nei's matrix using the script wgd_arenosa_Nei_natrix.R. The script is a shortened version of the lab script adegenet_Ana_version.R provided by L.Yant.

- Download SplitsTree from  https://uni-tuebingen.de/en/fakultaeten/mathematisch-naturwissenschaftliche-fakultaet/fachbereiche/informatik/lehrstuehle/algorithms-in-bioinformatics/software/splitstree/ , following the instructions on the webpage

- Upload the matrix (WGD_arenosa_Neis_distance.dst) into SplitsTree (version 4.19.2, built 22 Sep 2023) and click on File - open to create the network

- I then added a label denoting diploid or tetraploid for each population in Preview using the excel file WGD_samples as a guide

Script == wgd_arenosa_Nei_natrix.R
Input file == wgd_arenosa.fourfold_filtered_pruned.vcf
Output file == WGD_arenosa_Neis_distance.dst