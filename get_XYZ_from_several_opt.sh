#!/bin/bash


# Author:
# Elizabeth E. Wait
#     University of Texas at Austin
#     Dr. Pengyu Ren's group
# 2024

# Purpose:
# Get XYZ files of G16 optimized geometries for all ions in list

# Notes:
# Start in dir that is one above optimization (*.chk) files
# Must have G16 installed and set up
# Must have element_list.txt


G16_bashrc="/home/user/.g16.bashrc"                 # path to your G16 bashrc, see their instructions
dir="/path/to/working/directory"                    # parent dir containing opt dirs for each element
ligand="water"                                      # ligand or coordination complex
run="opt"                                           # name of run, in my case "opt" is the rest of the file base
echo "source ${G16_bashrc}" > ${dir}/run_getXYZ.sh  # create file w/ newzmat jobs and write line to source G16 rc

source ${G16_bashrc}
while IFS= read -r line; do
    element=$(echo ${line} | awk '{ print $1 }' )   # ion element
    file_base="${element}_${ligand}_${run}"         # should match *.chk
    newzline="cd ${dir}/${element} ; newzmat -ichk -oxyz ${file_base}.chk"
    echo "${newzline}" >> ${dir}/run_getXYZ.sh
    echo "sleep 5" >> ${dir}/run_getXYZ.sh
done < ${dir}/element_list.txt

# run_getXYZ.sh has been created with all newzmat commands to do
# now run run_getXYZ.sh in background
nohup bash run_getXYZ.sh &

