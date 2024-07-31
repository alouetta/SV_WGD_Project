# Preparation of SV VCF for genome scanning
The instructions below are for filtering and indexing the SV VCF data prior to genome scanning. The HPC is used and so the commands for loading the required packages are given. Where numbers of samples, variants etc. are checked, the expected number using the specified input data is given in brackets.

**Input data == WGD_WCarp_all_SV50_norm_rmdup_AN_AC.vcf.gz**

**Packages == bcftools v1.18**

**Output data == WGD_WCarp_all_SV50_norm_rmdup_AN_AC_DP_miss_poly.vcf**

## Methods 

1) Copying structural variant VCF over to ~/Data

- cp WGD_WCarp_all_SV50_norm_rmdup_AN_AC.vcf.gz ~/Data

2) Check number of samples and variants in VCF

- First, load bcftools module onto HPC: module load bcftools-uoneasy/1.18-GCC-13.2.0

- Sample number:
bcftools query -l WGD_WCarp_all_SV50_norm_rmdup_AN_AC.vcf.gz | wc -l 

(149)

- Variant number:
bcftools view -H WGD_WCarp_all_SV50_norm_rmdup_AN_AC.vcf.gz | wc -L

(99187)

3) Change ID in header
ID is still in SNP format so need to change it to only include what we need.

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

8) Download data to use in R etc.
scp username@hpclogin02.ada.nottingham.ac.uk:/gpfs01/home/username/Data/WGD_WCarp_all_SV50_norm_rmdup_AN_AC_DP_miss_poly.vcf ./OneDrive/Adaptation_to\ polyploidy_project 
