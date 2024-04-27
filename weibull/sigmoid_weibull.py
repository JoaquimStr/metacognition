import pandas as pd
import numpy as np
from scipy.optimize import curve_fit
import matplotlib.pyplot as plt

# Load data from Excel file
awake_data = pd.read_excel(r"C:\Metacognition_Project\HMETA\DATA_28april2024\behaviour_analysis\all_behav_W.xlsx")
drowsy_data = pd.read_excel(r"C:\Metacognition_Project\HMETA\DATA_28april2024\behaviour_analysis\all_behav_S.xlsx")

# Extract accuracy and difficulty columns
accuracy_W = awake_data["behav_data_10"] == awake_data["behav_data_11"]
difficulty_W = awake_data["behav_data_ 3"]
subjects_W = awake_data["behav_data_ 1"]

accuracy_S = drowsy_data["behav_data_10"] == drowsy_data["behav_data_11"]
difficulty_S = drowsy_data["behav_data_ 3"]
subjects_S = drowsy_data["behav_data_ 1"]

# Calculate proportion of right responses per merging level for each subject
proportions_W = awake_data.groupby(['behav_data_ 1', 'behav_data_ 3']).apply(lambda x: np.mean(x['behav_data_10'] == x['behav_data_11'])).reset_index(name='proportion')
proportions_S = drowsy_data.groupby(['behav_data_ 1', 'behav_data_ 3']).apply(lambda x: np.mean(x['behav_data_10'] == x['behav_data_11'])).reset_index(name='proportion')

# Calculate mean and standard deviation of proportions for each tone level
mean_proportions_W = proportions_W.groupby('behav_data_ 3')['proportion'].mean()
std_proportions_W = proportions_W.groupby('behav_data_ 3')['proportion'].std()

mean_proportions_S = proportions_S.groupby('behav_data_ 3')['proportion'].mean()
std_proportions_S = proportions_S.groupby('behav_data_ 3')['proportion'].std()

# Extract tone values
tone_values_W = mean_proportions_W.index
tone_values_S = mean_proportions_S.index

mean_proportions_W[0:4] = 1 - mean_proportions_W[0:4]
mean_proportions_S[0:4] = 1 - mean_proportions_S[0:4]

'''
# Calculate proportion of right responses per merging level
proportions_W = []
tone_values_W = np.unique(difficulty_W)
proportions_S = []
tone_values_S = np.unique(difficulty_S)


proportions_W = np.zeros_like(np.unique(difficulty_W), dtype=float)
proportions_S = np.zeros_like(np.unique(difficulty_S), dtype=float)

for i, value in enumerate(np.unique(difficulty_W)):
    mask_W = difficulty_W == value
    proportions_W[i] = np.mean(accuracy_W[mask_W])
    
for i, value in enumerate(np.unique(difficulty_S)):
    mask_S = difficulty_S == value
    proportions_S[i] = np.mean(accuracy_S[mask_S])

proportions_W[0:4] = 1 - proportions_W[0:4]
proportions_S[0:4] = 1 - proportions_S[0:4]



# Define Weibull function
def weibull(x, alpha, beta):
    return 1 - np.exp(-np.power((x / alpha), beta))

# Fit Weibull function to data
popt_W, pcov_W = curve_fit(weibull, tone_values_W, proportions_W, method='dogbox')
popt_S, pcov_S = curve_fit(weibull, tone_values_S, proportions_S, method='dogbox')

# Calculate confidence intervals for parameters
alpha_W, beta_W = popt_W
alpha_S, beta_S = popt_S

alpha_err_W, beta_err_W = np.sqrt(np.diag(pcov_W))
alpha_err_S, beta_err_S = np.sqrt(np.diag(pcov_S))

# Plot data and fitted Weibull curve with confidence intervals
plt.plot(tone_values_W, weibull(tone_values_W, *popt_W), color='red', label='Awake')
plt.plot(tone_values_S, weibull(tone_values_S, *popt_S), color='blue', label='Drowsy')

# Plot data points with error bars (95% confidence intervals)
plt.errorbar(tone_values_W, proportions_W, yerr=1.96 * alpha_err_W, fmt='o', color='red', label='Awake Data')
plt.errorbar(tone_values_S, proportions_S, yerr=1.96 * alpha_err_S, fmt='o', color='blue', label='Drowsy Data')

plt.xlabel('% tone in stimuli')
plt.ylabel('Proportion of right responses')
plt.xticks(tone_values_W)
ax = plt.gca()
ax.set_ylim([-0.1, 1.1])
plt.legend()
plt.show()

# Print parameters of the fitted Weibull curve
print("Fitted Weibull parameters for awake session:")
print("alpha =", alpha_W, "+/-", alpha_err_W)
print("beta =", beta_W, "+/-", beta_err_W)

print("\nFitted Weibull parameters for drowsy session:")
print("alpha =", alpha_S, "+/-", alpha_err_S)
print("beta =", beta_S, "+/-", beta_err_S)

''' 

# Define Weibull function
def weibull(x, alpha, beta):
    return 1 - np.exp(-np.power((x / alpha), beta))

# Fit Weibull function to data
popt_W, pcov_W = curve_fit(weibull, tone_values_W, mean_proportions_W, method='dogbox')
popt_S, pcov_S = curve_fit(weibull, tone_values_S, mean_proportions_S, method='dogbox')

# Plot data and fitted Weibull curve with error bars
plt.errorbar(tone_values_W, mean_proportions_W, yerr=std_proportions_W, fmt='o', color='red', label='Awake Data')
plt.errorbar(tone_values_S, mean_proportions_S, yerr=std_proportions_S, fmt='o', color='blue', label='Drowsy Data')

plt.plot(tone_values_W, weibull(tone_values_W, *popt_W), color='red', label='Awake Fit')
plt.plot(tone_values_S, weibull(tone_values_S, *popt_S), color='blue', label='Drowsy Fit')

plt.xlabel('% tone in stimuli')
plt.ylabel('Proportion of right responses')
plt.xticks(tone_values_W)
ax = plt.gca()
ax.set_ylim([0, 1])
plt.legend()
plt.show()

# Print parameters of the fitted Weibull curve
print("Fitted Weibull parameters for awake session:")
print("alpha =", popt_W[0])
print("beta =", popt_W[1])

print("\nFitted Weibull parameters for drowsy session:")
print("alpha =", popt_S[0])
print("beta =", popt_S[1])