#!/bin/bash
#SBATCH --job-name=entropy_wgd_arenosa
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=50g
#SBATCH --time=10:00:00
#SBATCH --output=Data/Output_error_files/%x.out
#SBATCH --error=Data/Output_error_files/%x.err

## This script is to run entropy on snp data to produce hdf5 files for plotting admixture proportions in R. It is run 3 times to produce 3 chains for each value of K. On the 2nd and 3rd runs the output file names must be amended to reflect chain 2 and 3 respectively.
## It requires an mpgl file and qk[2-11]inds.txt files created from vcf data using the entropy script inputdataformat.R and a text file showing the ploidy of each population (ploidy_inds.txt)
## This script was taken from (https://bitbucket.org/buerklelab/mixedploidy-entropy/src/master/) and altered only to allow extra k values 9 to 11. See the entropy manual vignette_entropy.pdf for further details of input file format.

# source home profile 
source $HOME/.bash_profile

# activate environment with Entropy
conda activate entropy_env 

# make a directory for entropy output files
mkdir -p Data/Entropy

# run entropy for K values 2-11
entropy -i Data/wgd_arenosa.fourfold_filtered_pruned.mpgl -n Data/ploidy_inds.txt -k 2 -q Data/qk2inds.txt -l 3000 -b 1000 -t 20 -o Data/Entropy/wgd_arenosak2chain1.hdf5

entropy -i Data/wgd_arenosa.fourfold_filtered_pruned.mpgl -n Data/ploidy_inds.txt -k 3 -q Data/qk3inds.txt -l 3000 -b 1000 -t 20 -o Data/Entropy/wgd_arenosak3chain1.hdf5

entropy -i Data/wgd_arenosa.fourfold_filtered_pruned.mpgl -n Data/ploidy_inds.txt -k 4 -q Data/qk4inds.txt -l 3000 -b 1000 -t 20 -o Data/Entropy/wgd_arenosak4chain1.hdf5

entropy -i Data/wgd_arenosa.fourfold_filtered_pruned.mpgl -n Data/ploidy_inds.txt -k 5 -q Data/qk5inds.txt -l 3000 -b 1000 -t 20 -o Data/Entropy/wgd_arenosak5chain1.hdf5

entropy -i Data/wgd_arenosa.fourfold_filtered_pruned.mpgl -n Data/ploidy_inds.txt -k 6 -q Data/qk6inds.txt -l 3000 -b 1000 -t 20 -o Data/Entropy/wgd_arenosak6chain1.hdf5

entropy -i Data/wgd_arenosa.fourfold_filtered_pruned.mpgl -n Data/ploidy_inds.txt -k 7 -q Data/qk7inds.txt -l 3000 -b 1000 -t 20 -o Data/Entropy/wgd_arenosak7chain1.hdf5

entropy -i Data/wgd_arenosa.fourfold_filtered_pruned.mpgl -n Data/ploidy_inds.txt -k 8 -q Data/qk8inds.txt -l 3000 -b 1000 -t 20 -o Data/Entropy/wgd_arenosak8chain1.hdf5

entropy -i Data/wgd_arenosa.fourfold_filtered_pruned.mpgl -n Data/ploidy_inds.txt -k 9 -q Data/qk9inds.txt -l 3000 -b 1000 -t 20 -o Data/Entropy/wgd_arenosak9chain1.hdf5

entropy -i Data/wgd_arenosa.fourfold_filtered_pruned.mpgl -n Data/ploidy_inds.txt -k 10 -q Data/qk10inds.txt -l 3000 -b 1000 -t 20 -o Data/Entropy/wgd_arenosak10chain1.hdf5

entropy -i Data/wgd_arenosa.fourfold_filtered_pruned.mpgl -n Data/ploidy_inds.txt -k 11 -q Data/qk11inds.txt -l 3000 -b 1000 -t 20 -o Data/Entropy/wgd_arenosak11chain1.hdf5



# get job id
echo "The Job ID for this job is: $SLURM_JOB_ID"
