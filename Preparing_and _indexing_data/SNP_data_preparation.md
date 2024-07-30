# Data preparation

1) Creating new directory in homedrive and copying data over
mkdir Data
cp wgd_arenosa.fourfold.v2.vcf.gz ~/Data

2) Check number of samples in file, number of variants and mean depth

- First, load bcftools module onto HPC using load bcftools: module load bcftools-uoneasy/1.18-GCC-13.2.0

- Sample number:
bcftools query -l wgd_arenosa.fourfold.v2.vcf.gz | wc -l 
159
- Variant number
bcftools view -H wgd_arenosa.fourfold.v2.vcf.gz | wc -L
3232322
- Mean depth
bcftools query -f '[%DP\t]\n' remove_zeroDPs_wgd_arenosa.vcf.gz | awk '{sum += $1; n++} END {if (n > 0) print "Mean Depth:", sum / n; else print "No variants found"}'
34.6198

3) Create an index file 

- Load htslib on to HPC using module load htslib-uoneasy/1.18-GCC-13.2.0

- tabix -p vcf wgd_arenosa.fourfold.filtered.vcf.gz

4) Filter vcf for depth<10

- bcftools filter -S . -e 'FORMAT/DP<10' -Oz -o wgd_arenosa.fourfold.DP10.vcf.gz Data/wgd_arenosa.fourfold.v2.vcf.gz

- Check variant number: bcftools view -H wgd_arenosa.fourfold.DP10.vcf.gz | wc -l
3232322

5) Filter for missingness <0.1 

- bcftools filter -i 'F_MISSING < 0.1' -Oz -o wgd_arenosa.fourfold.DP10.MISS10vcf.gz Data/wgd_arenosa.fourfold.DP10.vcf.gz

- Check variant number: bcftools view -H wgd_arenosa.fourfold.DP10.MISS10vcf.gz | wc -l
471366

6) Pruning for linkage

- Convert vcf to a bcf file : bcftools view wgd_arenosa.fourfold.DP10.MISS10vcf.gz -O b -o wgd_arenosa.fourfold.DP10.MISS10.bcf

- Prune using bcftools plugin +prune: bcftools +prune -m 0.4 -w 1000 wgd_arenosa.fourfold.DP10.MISS10.bcf -Ob -o wgd_arenosa_bcf.4_pruned.bcf

- Convert bcf to a vcf file : bcftools view wgd_arenosa_bcf.4_pruned.bcf  -O v -o wgd_arenosa_bcf.4_pruned.vcf

- Check variant number : bcftools view -H wgd_arenosa_bcf.4_pruned.vcf | wc -l
48631

7) Download data to use in R etc.
scp mbxvm2@hpclogin02.ada.nottingham.ac.uk:/gpfs01/home/mbxvm2/Data/wgd_arenosa_bcf.4_pruned.vcf ./OneDrive/Adaptation_to\ polyploidy_project 
