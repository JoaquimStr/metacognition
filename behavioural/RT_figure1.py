# -*- coding: utf-8 -*-
"""
Created on Fri Feb 16 09:50:35 2024

@author: strei
"""

import numpy as np
import matplotlib.pyplot as plt
import scipy.io
import glob
import statistics

directory_path = r'C:\Metacognition_Project\HMETA\DATA_28april2024\behaviour_analysis\\'
drowsy_pattern = '*behav_ready_S*'
awake_pattern = '*behav_ready_W*'

# Use glob to find all files that match the pattern
drowsy_files = glob.glob(directory_path + drowsy_pattern)
awake_files = glob.glob(directory_path + awake_pattern)

drowsy_RT = []
awake_RT = []

# Load and process each drowsy file
for file_path in drowsy_files:
    drowsy_variable = scipy.io.loadmat(file_path)
    drowsy_data = drowsy_variable['behav_data']
    drowsy_RT.append(drowsy_data[:, 5])

# Load and process each awake file
for file_path in awake_files:
    awake_variable = scipy.io.loadmat(file_path)
    awake_data = awake_variable['behav_data']
    awake_RT.append(awake_data[:, 5])

# Concatenate lists into numpy arrays if needed
drowsy_RT = np.concatenate(drowsy_RT)
awake_RT = np.concatenate(awake_RT)

median_drowsy = statistics.median(drowsy_RT);
median_awake = statistics.median(awake_RT);
mean_drowsy = statistics.mean(drowsy_RT);
mean_awake = statistics.mean(awake_RT);

# Plot histograms for both conditions
plt.hist(awake_RT, bins='auto', density=True, color='red', alpha=0.7, label='Awake')
plt.hist(drowsy_RT, bins='auto', density=True, color='blue', alpha=0.7, label='Drowsy')
plt.plot([median_awake, median_awake], [0,2.3], linestyle='dashed', color='red', linewidth=2)
plt.plot([median_drowsy, median_drowsy], [0,2.3], linestyle='dashed', color='blue', linewidth=2)

# Add labels and title
plt.xlabel('Reaction Time (sec)')
plt.ylabel('Density')
plt.title('Distribution of Reaction Time in Drowsy and Awake Sessions')

# Add legend
plt.legend()

# Show plot
plt.show()