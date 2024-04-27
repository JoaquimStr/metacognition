# -*- coding: utf-8 -*-
"""
Created on Fri Apr  5 10:15:59 2024

@author: strei
"""

import os
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from scipy.stats import ttest_ind

# Define the folder path (use raw strings for Windows paths)
folder = r'C:\Metacognition_Project\newDrowsyIndexing\newIndexing\results'
# os.chdir(folder) # Only necessary if you need to change the working directory

# Initialize arrays
d = np.zeros((30, 2))
meta = np.zeros((30, 2))
ratio = np.zeros((30, 2))

alertness = ['Awake', 'Drowsy']

# Assuming group_W and group_S_newIndexing are loaded or defined elsewhere in your Python script
for n in range(30): # Python uses 0-based indexing
    d[n, 0] = group_W['d1'][0, n]
    d[n, 1] = group_S_newIndexing['d1'][0, n]
    meta[n, 0] = group_W['meta_d'][0, n]
    meta[n, 1] = group_S_newIndexing['meta_d'][0, n]
    ratio[n, 0] = group_W['Mratio'][0, n]
    ratio[n, 1] = group_S_newIndexing['Mratio'][0, n]

# Function to plot data
def plot_data(data, title, ylabel, filename):
    plt.figure()
    sns.boxplot(data=pd.DataFrame(data, columns=alertness), palette=['r', 'b'])
    plt.title(title)
    plt.ylabel(ylabel)
    plt.ylim(0, 4)
    # Save the plot
    plt.savefig(filename)
    plt.close()

# Plotting
plot_data(d, 'Discrimination performance (d\')', 'd\'', 'd.jpg')
plot_data(meta, 'Metacognitive performance (meta-d\')', 'meta-d\'', 'meta.jpg')
plot_data(ratio, 'Metacognitive efficiency (HMeta-d\'/d\')', 'HMeta-d\'/d\'', 'ratio.jpg')

# T-tests
h1, p1 = ttest_ind(d[:, 0], d[:, 1])

# Print mean values as a simple example of statistical analysis
d1_mean = np.mean(d[:, 0])
d2_mean = np.mean(d[:, 1])

meta1_mean = np.mean(meta[:, 0])
meta2_mean = np.mean(meta[:, 1])

ratio1_mean = np.mean(ratio[:, 0])
ratio2_mean = np.mean(ratio[:, 1])

print(f"d1 mean: {d1_mean}, d2 mean: {d2_mean}")
print(f"meta1 mean: {meta1_mean}, meta2 mean: {meta2_mean}")
print(f"ratio1 mean: {ratio1_mean}, ratio2 mean: {ratio2_mean}")
