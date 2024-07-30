## This script creates a Nei's distance matrix to upload to Splitstree to create a phylogenetic tree. The code
## is an unaltered excerpt (apart from some additional annotation) from the script 'adegenet_Ana_version.R' provided by Levi Yant 
## and presented separately in this script for ease of use.

setwd("path/to/your/files")

# If not already installed, install the following packages or go straight to library calling below.
install.packages("adegenet", dep=TRUE)
install.packages("StAMPP")
install.packages("vcfR")


# Call the libraries:
library(adegenet)
library(StAMPP)
library(vcfR)


# This setting should print warnings as they occur
options(warn=1)

################################################################################
######################=========MODIFIED FUNCTIONS=========######################

# Create a function for conversion from vcfR object to genlight in tetraploids

vcfR2genlight.tetra <- function (x, n.cores = 1) 
{
  bi <- is.biallelic(x)
  if (sum(!bi) > 0) {
    msg <- paste("Found", sum(!bi), "loci with more than two alleles.")
    msg <- c(msg, "\n", paste("Objects of class genlight only support loci with two alleles."))
    msg <- c(msg, "\n", paste(sum(!bi), "loci will be omitted from the genlight object."))
    warning(msg)
    x <- x[bi, ]
  }
  x <- addID(x)
  CHROM <- x@fix[, "CHROM"]
  POS <- x@fix[, "POS"]
  ID <- x@fix[, "ID"]
  x <- extract.gt(x)
  x[x == "0|0"] <- 0     
  x[x == "0|1"] <- 1     
  x[x == "1|0"] <- 1     
  x[x == "1|1"] <- 2     
  x[x == "0/0"] <- 0     
  x[x == "0/1"] <- 1     
  x[x == "1/0"] <- 1     
  x[x == "1/1"] <- 2     
  x[x == "1/1/1/1"] <- 4
  x[x == "0/1/1/1"] <- 3
  x[x == "0/0/1/1"] <- 2
  x[x == "0/0/0/1"] <- 1
  x[x == "0/0/0/0"] <- 0
  x[x == "0/0/0/0/0/0"] <- 0
  x[x == "0/0/0/0/0/1"] <- 1
  x[x == "0/0/0/0/1/1"] <- 2
  x[x == "0/0/0/1/1/1"] <- 3
  x[x == "0/0/1/1/1/1"] <- 4
  x[x == "0/1/1/1/1/1"] <- 5
  x[x == "1/1/1/1/1/1"] <- 6
  if (requireNamespace("adegenet")) {
    x <- new("genlight", t(x), n.cores = n.cores)
  }
  else {
    warning("adegenet not installed")
  }
  adegenet::chromosome(x) <- CHROM
  adegenet::position(x) <- POS
  adegenet::locNames(x) <- ID
  return(x)
}

################################################################################
######################===========GET_THE_DATA=============######################
# IMPORT SNP data from VCF
vcf <- read.vcfR("wgd_arenosa.fourfold_filtered_pruned.vcf")  


# convert to genlight 	
# This uses the modified function vcfR2genlight.tetra
aa.genlight <- vcfR2genlight.tetra(vcf)
locNames(aa.genlight) <- paste(vcf@fix[,1],vcf@fix[,2],sep="_")  # add real SNP.names
pop(aa.genlight)<-substr(indNames(aa.genlight),1,3)   # add pop names: here pop names are first 3 chars of ind name


# check that population names and ploidy values are all present and correct   =====VERY IMPORTANT===
aa.genlight$pop
indNames(aa.genlight)
ploidy(aa.genlight)

################################################################################
######################=========NEI"S DISTANCE MATRIX=========######################



# Calculate Nei's distances between populations


aa.D.pop <- stamppNeisD(aa.genlight, pop = TRUE)   # Nei's 1972 distance between pops
# export matrix - for SplitsTree
stamppPhylip(aa.D.pop, file="WGD_arenosa_Neis_distance.dst") 



















