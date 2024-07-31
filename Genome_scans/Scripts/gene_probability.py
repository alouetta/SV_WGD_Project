# This script was used to calculate the probability of finding 2 meiosis genes in our random list of 222 genes.

import scipy.stats as stats

# Define the values
N = 25550  # total number of genes
K = 62     # number of meiosis genes
n = 222    # size of the random list
k = 2      # number of meiosis genes found in the random list

# Calculate the probability of finding exactly k meiosis genes
probability_exact_k = stats.hypergeom.pmf(k, N, K, n)

print(f"Probability of finding exactly {k} meiosis genes in a random list of {n} genes {probability_exact_k:.4e}")
