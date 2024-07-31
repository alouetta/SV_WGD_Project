## Rscript to assess convergence of parameters in a hdf5 file output by entropy 

## Sep 2019 -- vshastry

library(rhdf5)

#args<-commandArgs(TRUE)

#f<-as.character(args[1])
f<- "~/OneDrive/Adaptation_to polyploidy_project/Pop_genetics/Entropy/Entropy_outputs/Traces/wgd_arenosak11trace.hdf5"

w.q<-h5read(f,"q")
pdf("~/OneDrive/Adaptation_to polyploidy_project/Pop_genetics/Entropy/Entropy_outputs/Traces/k11_Trace_plot3.pdf", width=5, height=5)
par(mfrow=c(2,2))
plot(w.q[,sample(1:dim(w.q)[2],1),sample(1:dim(w.q)[3],1)],type="l",ylab='')
plot(w.q[,sample(1:dim(w.q)[2],1),sample(1:dim(w.q)[3],1)],type="l",ylab='')
plot(w.q[,sample(1:dim(w.q)[2],1),sample(1:dim(w.q)[3],1)],type="l",ylab='')
plot(w.q[,sample(1:dim(w.q)[2],1),sample(1:dim(w.q)[3],1)],type="l",ylab='')
mtext("Trace plots 9-12 for admixture estimates (k=11)", outer = TRUE, side=3, line=-2)

dev.off()

## Remainder of the script not used
w.p<-h5read(f,"p")

par(mfrow=c(2,2))
plot(w.p[,sample(1:dim(w.p)[2],1),sample(1:dim(w.p)[3],1)],type="l",ylab='')
plot(w.p[,sample(1:dim(w.p)[2],1),sample(1:dim(w.p)[3],1)],type="l",ylab='')
plot(w.p[,sample(1:dim(w.p)[2],1),sample(1:dim(w.p)[3],1)],type="l",ylab='')
plot(w.p[,sample(1:dim(w.p)[2],1),sample(1:dim(w.p)[3],1)],type="l",ylab='')
mtext("Trace plots for allele freq. estimates", outer = TRUE, side=3, line=-2)

