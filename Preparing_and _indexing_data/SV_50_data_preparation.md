# Preparation of SV VCF for genome scanning
Below are the steps to follow to process the SV VCF file before genome acanning. All steps were carried out on the HPC. If a package is required such as bcftools, instructions for loading the correct module are given. For checking variant numbers, sample numbers etc. the expected number is given in brackets for the input data we used.

**Input data == WGD_WCarp_all_SV50_norm_rmdup_AN_AC.vcf.gz**

**Packages used == bcftools v 1.18**


1) Copying structural variant VCF over to ~/Data
cp WGD_WCarp_all_SV50_norm_rmdup_AN_AC.vcf.gz ~/Data

2) Check number of samples and variants in VCF

- First, load bcftools module onto HPC using load bcftools: module load bcftools-uoneasy/1.18-GCC-13.2.0

- Sample number:
bcftools query -l WGD_WCarp_all_SV50_norm_rmdup_AN_AC.vcf.gz | wc -l

(149)

- Variant number:
bcftools view -H WGD_WCarp_all_SV50_norm_rmdup_AN_AC.vcf.gz | wc -L

(99187)

3) Change ID in header
Header was in still in SNP format so was shortened:

bcftools annotate --set-id '%CHROM\_%POS\_%INFO/SVTYPE\_%INFO/SVLEN' -o 
WGD_WCarp_all_SV50_temp.vcf WGD_WCarp_all_SV50_norm_rmdup_AN_AC.vcf

4) Create an index file 

- Load htslib on to HPC using module load htslib-uoneasy/1.18-GCC-13.2.0

- tabix -p vcf WGD_WCarp_all_SV50_norm_rmdup_AN_AC.vcf.gz

5) Filter vcf for depth>=5

- bcftools filter -S . -i 'FMT/DP>=5' WGD_WCarp_all_SV50_temp.vcf > WGD_WCarp_all_SV50_norm_rmdup_AN_AC_DP.vcf

- Check variant number:
bcftools view -H WGD_WCarp_all_SV50_norm_rmdup_AN_AC_DP.vcf | wc -l

(99187)

6) Filter for missingness <0.2

- bcftools filter -i 'F_MISSING<0.2' WGD_WCarp_all_SV50_norm_rmdup_AN_AC_DP.vcf > WGD_WCarp_all_SV50_norm_rmdup_AN_AC_DP_miss.vcf

- Check variant number: 
bcftools view -H WGD_WCarp_all_SV50_norm_rmdup_AN_AC_DP_miss.vcf | wc -l

(33805)

7) Filter for samples where ac = 0 or equal to an i.e. leaving only polymorphic variants

- bcftools view -e 'AC=0 || AC==AN' WGD_WCarp_all_SV50_norm_rmdup_AN_AC_DP_miss.vcf > WGD_WCarp_all_SV50_norm_rmdup_AN_AC_DP_miss_poly.vcf

- Check variant no:
bcftools view -H WGD_WCarp_all_SV50_norm_rmdup_AN_AC_DP_miss_poly.vcf | wc -l

(21013)

8) Download data to use in R etc:
   
scp username@hpclogin02.ada.nottingham.ac.uk:/gpfs01/home/username/Data/WGD_WCarp_all_SV50_norm_rmdup_AN_AC_DP_miss_poly.vcf ./OneDrive/Adaptation_to\ polyploidy_project 
