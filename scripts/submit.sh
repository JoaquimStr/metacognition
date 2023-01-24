#!/bin/bash
#SBATCH -A BEKINSCHTEIN-SL3-CPU
#SBATCH -p icelake-himem
#SBATCH --array=1-25
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH -t 5:00:00
#SBATCH -J confscore
#SBATCH -o logs/confscore_%A_%a.out
#SBATCH -e logs/confscore_%A_%a.err

###############################
#  DO NOT CHANGE THESE LINES
. /etc/profile.d/modules.sh
module purge
module load rhel8/default-icl
###############################

module load matlab
cd ~/metacognition 
matlab -nodesktop -nosplash -r "main(${SLURM_ARRAY_TASK_ID}); quit"

