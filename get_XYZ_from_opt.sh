# Author:
# Elizabeth E. Wait
#     University of Texas at Austin
#     Dr. Pengyu Ren's group
# 2024

# Purpose:
# Example of how to get XYZ from a Gaussian16 checkpoint file
# Intended for getting optimized geometry after running optimization

# Notes:
# Start in dir that has input (*.chk) file
# Must have G16 installed and set up

G16_bashrc="/home/user/.g16.bashrc"   # path to your G16 bashrc, see their instructions
dir="/path/to/working/directory"
file_base="La_water_opt"              # file base name which should match *.chk

source $G16_bashrc
cd $dir ; newzmat -ichk -oxyz ${file_base}.chk
