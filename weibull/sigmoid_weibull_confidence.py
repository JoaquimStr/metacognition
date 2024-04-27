# -*- coding: utf-8 -*-
"""
Created on Wed Apr  3 16:45:39 2024

@author: strei
"""

# -*- coding: utf-8 -*-
"""
Created on Wed Apr  3 16:04:39 2024

@author: strei
"""

import pandas as pd
import numpy as np
from scipy.optimize import curve_fit
import matplotlib.pyplot as plt

# Define a function to load and process data
def load_and_process_data(file_path):
    data = pd.read_excel(file_path)
    # Calculate proportion of right responses per merging level for each subject
    abs_average = data.groupby(['behav_data_ 3'])['behav_data_ 4'].apply(lambda x: x.abs()).reset_index(name='abs_average_confidence')
    # Aggregate mean and std of proportions for each difficulty level
    mean_proportions = abs_average.groupby(['behav_data_ 3'])['abs_average'].mean()
    std_proportions = abs_average.groupby(['behav_data_ 3'])['abs_average'].std()
    # Adjust proportions for the first four levels
    mean_proportions.iloc[0:4] = 1 - mean_proportions.iloc[0:4]
    return mean_proportions, std_proportions, mean_proportions.index

# Load data
awake_path = r"C:\Metacognition_Project\HMETA\DATA_28april2024\behaviour_analysis\all_behav_W.xlsx"
drowsy_path = r"C:\Metacognition_Project\HMETA\DATA_28april2024\behaviour_analysis\all_behav_S.xlsx"
mean_proportions_W, std_proportions_W, tone_values_W = load_and_process_data(awake_path)
mean_proportions_S, std_proportions_S, tone_values_S = load_and_process_data(drowsy_path)

n = 30
std_proportions_W = std_proportions_W / np.sqrt(n) 
std_proportions_S = std_proportions_S / np.sqrt(n) 

# Define Weibull function
def weibull(x, alpha, beta):
    return 1 - np.exp(-np.power((x / alpha), beta))

# Initial guesses for the Weibull parameters
initial_guess = [np.median(tone_values_S), 2.0] # Example guess, adjust based on your data.

# Bounds for the parameters: (alpha, beta)
# Assuming alpha > 0 and 0 < beta < 5, adjust the bounds as per your data characteristics.
bounds = ((0.01, 0), (np.inf, 6))

# Fit Weibull function to data with initial guesses and bounds
def fit_weibull(tone_values, proportions, initial, bounds):
    popt, pcov = curve_fit(weibull, tone_values, proportions, p0=initial, bounds=bounds, method='trf')
    return popt, pcov

# Fit for the Drowsy data
popt_S, pcov_S = fit_weibull(tone_values_S, mean_proportions_S, initial_guess, bounds)

# Fit Weibull function and plot for both conditions
def fit_and_plot(tone_values, mean_proportions, std_proportions, label_color, label):
    popt, pcov = curve_fit(weibull, tone_values, mean_proportions, method='dogbox')
    plt.errorbar(tone_values, mean_proportions, yerr=std_proportions, fmt='o', color=label_color)
    plt.plot(tone_values, weibull(tone_values, *popt), color=label_color, label= 'Awake')
    return popt

# Plotting
plt.figure(figsize=(10, 6))
popt_W = fit_and_plot(tone_values_W, mean_proportions_W, std_proportions_W, 'red', 'Awake')
# popt_S = fit_and_plot(tone_values_S, mean_proportions_S, std_proportions_S, 'blue', 'Drowsy')
plt.errorbar(tone_values_S, mean_proportions_S, yerr=std_proportions_S, fmt='o', color='blue')
plt.plot(tone_values_S, weibull(tone_values_S, *popt_S), color='blue', label='Drowsy')

plt.xlabel('% tone in stimuli')
plt.ylabel('Proportion of right responses')
plt.xticks(tone_values_W)
plt.ylim([-1.1, 1.1])
plt.legend()
plt.show()

# Print parameters of the fitted Weibull curve
print("Fitted Weibull parameters for awake session:")
print("alpha =", popt_W[0])
print("beta =", popt_W[1])

print("\nFitted Weibull parameters for drowsy session:")
print("alpha =", popt_S[0])
print("beta =", popt_S[1])
