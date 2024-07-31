# Instructions for installing and running Entropy

## Introduction
Entropy was used to illustrate the genetic composition of individuals in our populations to see how much of their ancestry is derived from different source populations. It involves creating an mpgl file from a vcf. The mpgl contains estimated genotypes for each individual at each genetic locus. The mpgl is then used to plot a barplot to show the composition of each population. All code was obtained from (https://bitbucket.org/buerklelab/mixedploidy-entropy/src/master/auxfiles/) and was used unchanged unless specified on the scripts. The version of Entropy used was v2.

## Installation

1) Install miniconda on the HPC using:
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
- Follow the installation steps (Enter, Space, “yes”, Enter, Enter) then wait for it to complete (~10 minutes)
- Once finished, logout with Ctrl+D then login again
- Add conda to your path permanently by adding the following commands to the file `~/.bash_profile:
PATH=$PATH:$HOME/.local/bin:$HOME/bin:~/miniconda3/condabin/
export PATH`

conda config --set auto_activate_base false

conda config --set env_prompt '({name})'

conda config --show

conda info

conda deactivate

2) Create an environment for Entropy
conda create entropy_env
conda init

3) Install entropy using conda
conda install popgen-entropy

version = 2.0 

## Running Entropy
Detailed instructions are in the manual vignette_entropy.pdf from (https://bitbucket.org/buerklelab/mixedploidy-entropy/src/master/auxfiles/). The manual contains more analyses than are needed for this project so the steps followed in this project are summarised below:

1) Create ploidy file
Create a text file (ploidy_inds.txt) with the ploidy of each sample by copying and pasting the ploidy column from the "WGD samples" excel file (in data folder).

Check that text file contains 159 lines using wc -l ploidy_inds.txt

2) Create mpgl file from vcf

**Script used == inputdataformat.R**

**Package == R v4.4**

**Input file == wgd_arenosa.fourfold_filtered_pruned.vcf**

**Output file == wgd_arenosa.fourfold_filtered_pruned.mpgl**

3) Run Entropy
Entropy ran for k=2 to 11 and repeated to get 3 chains for each k value.

**Script used == entropy.sh**

**Input file == wgd_arenosa.fourfold_filtered_pruned.mpgl**

**Output file == wgd_arenosakxchainy.hdf5 (where x = k and y = run no.)**

4) Create traces to assess convergence
Script run 3 times to get 3 lots of traces for each k.

**Script used == assessconvergence.R**

**Package == R v4.4**

**Input file == wgd_arenosakxchainy.hdf5 (where x = k and y = run no.)**

**Output files == kx_Trace_ploty.pdf (where x = k and y = run no.)**

5) Plot admixture results
   
**Script used == plotadmix.R**

**Input files == wgd_arenosakxchainy.hdf5 (where x = k and y = run no.)**

**Output files == admix_wgd_arenosa_2_5.pdf (for k = 2 to 5) admix_wgd_arenosa_2/11f.pdf (for k = 2-11)**









