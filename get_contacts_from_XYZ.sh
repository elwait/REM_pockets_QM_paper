#!/bin/bash


# Author:
# Elizabeth E. Wait
#     University of Texas at Austin
#     Dr. Pengyu Ren's group
# 2024

# Purpose:
# Compile coordinates of all atoms in each structure
# Intended for various lanthanide ions coordinated by several molecules

# How it works:
# For each element in list
#     Open xyz
#         For each line in xyz
#             Add line #, element, pocket, and run info and
#             print line to a new contacts.txt file
#         Remove lines containing H , C , or N so only ion and oxygens are left

# Notes:
# Start script in working dir which contains the *.xyz files
#     (*.xyz prepared previously, possibly with get_XYZ_from_opt.sh)
#     (example input dir: /REM_pockets_QM_paper/QM_coordination/distances/7CCO/7CCO_QM1)
# Make sure you have element_list.txt with atomic symbol and multiplicity
# The prepped contacts files will be used to analyze ion-O contact distances
#     This will be done with a separate python script (rem_contacts.py)


dir="/your/path/here"
element_list="${dir}/element_list.txt"
pocket="7CCO"                                     # name of coordinating
run="QM1"                                         # name of dataset if have multiple

while IFS= read -r line; do                       # for each line in element_list
    element=$(echo ${line} | awk '{ print $1 }' ) # ion element
    i=0                                           # start line counter for atom id numbers at 0
    # Write header for contacts.txt for that ion, pocket, and run
    echo "AtomNumber Ion Pocket OptRun Element X Y Z" > ${element}_${pocket}_${run}_contacts.txt
    while IFS= read -r coord_line; do             # for each line in xyz
        # write atom number from counter, ion element, pocket, run, and coordinates to contacts.txt
        echo "${i} ${element} ${pocket} ${run} ${coord_line}" >> ${element}_${pocket}_${run}_contacts.txt
        i=$((i+1)) # iterate counter for next line
    done < "${element}_${pocket}_${run}.xyz"
    sed -i '/H \|N \|C /d' ${element}_${pocket}_${run}_contacts.txt  # remove lines starting with H, N , or C
done < "${element_list}"

