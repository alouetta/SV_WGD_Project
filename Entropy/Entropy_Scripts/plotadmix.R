## R script to plot admixture proportions from inds
## This script has been adapted from the original plotadmix.R (https://bitbucket.org/buerklelab/mixedploidy-entropy/src/master/auxfiles/)
## to 1) amend plotting to just k=2-5, 2) improve labelling and,
## 3) to add the new installation instructions for the rhdf5 package


# Installing the rhdf5 package requires BiocManager install first (https://www.bioconductor.org/install/) 

if (!require("BiocManager", quietly = TRUE)) 
  install.packages("BiocManager")
BiocManager::install(version = "3.19")
BiocManager::install("rhdf5") 

install.packages("coda")

library(rhdf5)
library(coda)
set.seed(10041996)

mycols<-c("#9E0142","#FEE08B","#ABDDA4","#3288BD")

# reading the ind names from previously stored text file
inds.z<-read.table("~/OneDrive/Adaptation_to polyploidy_project/Pop_genetics/Entropy/Entropy_inputs/inds_wgd_arenosa.txt",sep="\n")
# creating a population label based on ind label
locs.z<-substr(inds.z[,1],1,3)

# create a list of unique population labels in the order they appear #Code added by V.Millar#
pop_labels <- unique(locs.z)

# create a list of the locations where the labels should appear on the plot #Code added by V.Millar#
pop_locations <-c(4, 14, 20, 23, 28, 40, 52, 59, 71, 78.5, 80, 84, 94, 104, 112, 123, 133, 141, 148, 156)

# writing the population labels for each ind into a text file (NOT USED)
#write.table(as.integer(as.factor(locs.z)), file="indlabel.txt", row.names=F, 
          #  col.names=F, quote=F)

# writing the population labels for plotting (NOT USED)
#write.table(cbind(1:length(unique(locs.z)), unique(locs.z)), file="poplabel.txt",
 #           row.names=F, col.names=F, quote=F)

# creating a pdf of admixture plots for all K #Code updated by V.Millar to just include k =2-5
pdf("~/OneDrive/Adaptation_to polyploidy_project/Pop_genetics/Entropy/Entropy_outputs/admix_wgd_arenosa_2_5.pdf", width=15, height=10)
par(mfrow=c(7,1), mgp=c(3, 0.1, 0))
for(k in 2:5){  
	if(k!=5)
		par(mar=c(1.2,2,0.7,1), mgp=c(3, 0.1, 0)) 
	else
		par(mar=c(2.4,2,0.7,1), mgp=c(3, 0.1, 0)) 

  # averaging over estimates from each chain
	qch1<-h5read(paste0("wgd_arenosak",k,"chain1.hdf5"),"q")
	qch2<-h5read(paste0("wgd_arenosak",k,"chain2.hdf5"),"q")
	qch3<-h5read(paste0("wgd_arenosak",k,"chain3.hdf5"),"q")

	qest1<-apply(qch1, c(2,3), mean)
	qest2<-apply(qch2, c(2,3), mean)
	qest3<-apply(qch3, c(2,3), mean)

	qest<-(qest1+qest2+qest3)/3

	# creating a simple Q-matrix file for use with CLUMPAK, pong, etc (NOT NEEDED)
	#write.table(format(t(qest), digits=5), file=paste0("simpleQ",k,".txt"), row.names=F, col.names=F, quote=F)

	# create barplot	
	barplot(qest, ylim=0:1, col=mycols[1:k], main=paste0("K=",k), border=NA, 
	        space=0, xaxt="n", yaxt="n")
	
	# adding population labels #Code added by V.Millar#
axis(1, at=pop_locations, labels=pop_labels, las=1.0, cex.axis=1, tick = FALSE)
}
dev.off()
