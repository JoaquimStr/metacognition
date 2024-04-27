# -*- coding: utf-8 -*-
"""
Created on Fri Feb 16 11:37:48 2024

@author: strei

"""
# plots sigmoids tone % and accuracy OR tone resp OR confidence ratios, 
# for both awake and drowsy sessions!

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

accuracy_S = drowsy_data["behav_data_10"] == drowsy_data["behav_data_11"]
difficulty_S = drowsy_data["behav_data_ 3"]

# Extract confidence columns
confidence_W = awake_data["behav_data_ 4"]
confidence_S = drowsy_data["behav_data_ 4"]



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


proportions_W[0:4] = 1-proportions_W[0:4]
proportions_S[0:4] = 1-proportions_S[0:4]


'''
# Define sigmoid function
def sigmoid(x, a, b, c):
    return c / (1 + np.exp(-a * (x - b)))

# Fit sigmoid function to data
popt, pcov = curve_fit(sigmoid, difficulty_values, proportions)


# Define sigmoid function
def sigmoid(x, a, b, c):
    return c / (1 + np.exp(-a * (x - b)))

# Fit sigmoid function to data
# Initial guess for parameters (a, b, c)
initial_guess = [0, np.mean(difficulty_values), 1]  
popt, pcov = curve_fit(sigmoid, difficulty_values, proportions, p0=initial_guess)

'''

# 1) sigmoid accuracy-difficulty awake/drowsy + add CI

def sigmoid(x, L ,x0, k, b):
    y = L / (1 + np.exp(-k*(x-x0))) + b
    return (y)

p0 = [max(proportions_W), np.median(tone_values_W),1,min(proportions_W)] # this is an mandatory initial guess
p0_S = [max(proportions_S), np.median(tone_values_S),1,min(proportions_S)]

popt, pcov = curve_fit(sigmoid, tone_values_W, proportions_W,p0, method='dogbox')
popt_S, pcov_S = curve_fit(sigmoid, tone_values_S, proportions_S, p0_S, method='dogbox')

# Plot data and fitted sigmoid curve
plt.plot(tone_values_W, sigmoid(tone_values_W, *popt), color='red', label='Awake')
plt.plot(tone_values_S, sigmoid(tone_values_S, *popt_S), color='blue', label='Drowsy')
plt.xlabel('% tone in stimuli')
plt.ylabel('Proportion of right responses')
plt.xticks(tone_values_W)
ax = plt.gca()
ax.set_ylim([0, 1])
plt.legend()
plt.show()

# Print parameters of the fitted sigmoid curve
print("Fitted sigmoid parameters:")
print("a =", popt[0])
print("b =", popt[1])
print("c =", popt[2])

'''
# 2) sigmoid accuracy-difficulty drowsy

p0 = [max(proportions_S), np.median(tone_values_S),1,min(proportions_S)] # this is an mandatory initial guess

popt, pcov = curve_fit(sigmoid, tone_values_S, proportions_S,p0, method='dogbox')

# Plot data and fitted sigmoid curve
plt.plot(tone_values_S, sigmoid(tone_values_S, *popt), color='blue', label='Awa')
plt.xlabel('% tone in stimuli')
plt.ylabel('Proportion of right responses')
plt.xticks(tone_values_S)
ax = plt.gca()
ax.set_ylim([0, 1])
plt.legend()
plt.show()

# Print parameters of the fitted sigmoid curve
print("Fitted sigmoid parameters:")
print("a =", popt[0])
print("b =", popt[1])
print("c =", popt[2])




'''
'''

# 3) sigmoid confidence and % tone awake

def sigmoid(x, L ,x0, k, b):
    y = L / (1 + np.exp(-k*(x-x0))) + b
    return (y)

p0 = [max(proportions), np.median(difficulty_values),1,min(proportions)] # this is an mandatory initial guess

popt, pcov = curve_fit(sigmoid, difficulty_values, proportions,p0, method='dogbox')

# Plot data and fitted sigmoid curve
plt.scatter(difficulty_values, proportions, label="Data")
plt.plot(difficulty_values, sigmoid(difficulty_values, *popt), color='red', label='Fitted sigmoid curve')
plt.xlabel('Dificulty')
plt.ylabel('Accuracy')
plt.xticks(difficulty_values)
ax = plt.gca()
ax.set_ylim([0, 1])
plt.legend()
plt.show()

# Print parameters of the fitted sigmoid curve
print("Fitted sigmoid parameters:")
print("a =", popt[0])
print("b =", popt[1])
print("c =", popt[2])

# 3) sigmoid confidence-tone_stim

def sigmoid(x, L ,x0, k, b):
    y = L / (1 + np.exp(-k*(x-x0))) + b
    return (y)

p0 = [max(proportions), np.median(difficulty_values),1,min(proportions)] # this is an mandatory initial guess

popt, pcov = curve_fit(sigmoid, difficulty_values, proportions,p0, method='dogbox')

# Plot data and fitted sigmoid curve
# plt.scatter(difficulty_values, proportions, label="Data")
plt.plot(difficulty_values, sigmoid(difficulty_values, *popt), color='red', label='Awake')
plt.plot(difficulty_values, sigmoid(difficulty_values_S, *popt), color='blue', label='Drowsy')
plt.xlabel('% tone')
plt.ylabel('Proportion of right responses')
plt.xticks(difficulty_values)
ax = plt.gca()
ax.set_ylim([0, 1])
plt.legend()
plt.show()

# Print parameters of the fitted sigmoid curve
print("Fitted sigmoid parameters:")
print("a =", popt[0])
print("b =", popt[1])
print("c =", popt[2])


# 4) sigmoid confidence and % tone drowsy

'''




