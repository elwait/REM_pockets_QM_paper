# Author:
# Elizabeth E. Wait
#     University of Texas at Austin
#     Dr. Pengyu Ren's group
# 2024

# Purpose:
# Example of how to submit a QChem job on Ren Lab cluster

# Notes:
# Start in dir that has input (*.in) file
# Make sure you have QChem set up
# Make sure you have bashrc for QChem environment
# run by:    (this will submit job on node for Ren Lab)
#     bash run_QChem_job.sh 

QC_bashrc="/home/user/qcenv.sh"   # path to QChem bashrc, see their instructions
file_base="Sm-water_eda"          # file base name which should match *.in

source  $QC_bashrc
qchem -nt 8 ${file_base}.in ${file_base}.out &
