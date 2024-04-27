import numpy as np
import matplotlib.pyplot as plt
from scipy.io import loadmat

# Load the .mat file
group_W = loadmat('group_W.mat')
group_S = loadmat('group_S.mat')

d = np.zeros((30, 2))
ratio = np.zeros((30, 2))

group_W = group_W['group_W'][0, 0]
group_S = group_S['group_S'][0, 0]

d[:,0] = group_W['d1']
d[:,1] = group_S['d1']

ratio[:,0] = group_W['Mratio']
ratio[:,1] = group_S['Mratio']

alertness = ['Awake', 'Drowsy']

#####
'''
# Create the boxplot with light fill colors
fig, ax = plt.subplots()
colors = ['lightcoral', 'lightblue']  # Light colors for the boxes
bp = ax.boxplot(d, patch_artist=True, 
                boxprops=dict(facecolor=colors[0], color='black'), 
                whiskerprops=dict(color='black'), medianprops=dict(color='black'),
                capprops=dict(color='black'), flierprops=dict(marker='o', color='black', markersize=7))

# Customizing box colors individually
for patch, color in zip(bp['boxes'], colors):
    patch.set_facecolor(color)

# Removing outliers visibility
for flier in bp['fliers']:
    flier.set_visible(False)

# Setting custom x-axis labels
ax.set_xticklabels(['', ''])

# Adding title and labels
# ax.set_title("Discrimination performance (d')")
ax.set_ylabel("d'")

# Setting y-axis limits
ax.set_ylim([0, 4])

# Overlay jittered scatter points and plot connections
for n in range(30):
    x1 = np.random.rand() * 0.4 + 1 - 0.2
    x2 = np.random.rand() * 0.4 + 2 - 0.2
    s1 = ax.plot(x1, d[n, 0], 'r.', markersize=10)[0]
    s2 = ax.plot(x2, d[n, 1], 'b.', markersize=10)[0]
    ax.plot([x1, x2], [d[n, 0], d[n, 1]], 'k-', linewidth = 0.1)  # Black lines connecting the points

# Adding a legend
ax.legend([s1, s2], ['Awake', 'Drowsy'], loc='upper right')

# Save the figure
plt.savefig('d.jpg')
plt.show()

####
'''

# Create the boxplot with light fill colors
fig, ax = plt.subplots()
colors = ['lightcoral', 'lightblue']  # Light colors for the boxes
bp = ax.boxplot(ratio, patch_artist=True, 
                boxprops=dict(facecolor=colors[0], color='black'), 
                whiskerprops=dict(color='black'), medianprops=dict(color='black'),
                capprops=dict(color='black'), flierprops=dict(marker='o', color='black', markersize=7))

# Customizing box colors individually
for patch, color in zip(bp['boxes'], colors):
    patch.set_facecolor(color)

# Removing outliers visibility
for flier in bp['fliers']:
    flier.set_visible(False)

# Setting custom x-axis labels
ax.set_xticklabels(['', ''])

# Adding title and labels
# ax.set_title("Metacognitive efficiency (Mratio)")
ax.set_ylabel("Hmeta-d'/d'")

# Setting y-axis limits
ax.set_ylim([0, 1])

# Overlay jittered scatter points and plot connections
for n in range(30):
    x1 = np.random.rand() * 0.4 + 1 - 0.2
    x2 = np.random.rand() * 0.4 + 2 - 0.2
    s1 = ax.plot(x1, ratio[n, 0], 'r.', markersize=10)[0]
    s2 = ax.plot(x2, ratio[n, 1], 'b.', markersize=10)[0]
    ax.plot([x1, x2], [ratio[n, 0], ratio[n, 1]], 'k-', linewidth = 0.1)  # Black lines connecting the points

# Adding a legend
ax.legend([s1, s2], alertness, loc='upper right')

# Save the figure
plt.savefig('ratio.jpg')
plt.show()