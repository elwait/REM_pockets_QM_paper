#!/bin/bash

# Purpose:
# Prepare input for QM binding calculations (REMs coordinated by multiple molecules)
# Current version creates jobs for each element for gas phase opt w/ 9 waters
# Lines for job submission are written to a *sh file also

# Notes: 
# Start script in working dir (ex: REM_pockets_QM_paper/QM_coordination/water/starting_structures)
# Make sure element_list.txt is in working dir
# Have template input files

#B3LYP/6-31G* & def2-TZVP (ion) for gas-phase opt and PCM cal (PCM does not work with DKH )
#B3LYP/Sapporo-DKH3-TZVP (ion) & def2-TZVP for gas-phase singe point energy w/ relativistic effect; “int=DKH”

# Alter the following variables for your needs:
g16_rc="/home/usr/.g16.bashrc"
template_dir="/REM_pockets_QM_paper/QM_coordination/starting_structures/water"
template="XX_water_opt.com"
# template should have everything you need to run except the element atomic symbol and basis set
# atomic symbol should be "XX" in the template file in coords and wherever else
# XX will be replaced with the atomic symbol
# multiplicity should also be represented by "mult" which will be replaced
# 
working_dir="/REM_pockets_QM_paper/QM_coordination/opt_QM1/water" 

# Basis set names and paths to files if downloaded from Basis Set Exchange
# Have multiple here because I switch depending on calculation type
basis1="def2tzvp"
basis1_dir="/REM_pockets_QM_paper/QM_coordination/basis_sets/def2tzvp"
# Example of basis set file name: Lu_def2tzvp.txt 
basis2="S-dkh3tzp"
basis2_dir="/REM_pockets_QM_paper/QM_coordination/basis_sets/sapporoDKH3TZP"
# Example of basis set file name: Lu_S-dkh3tzp.txt

run="opt"                                              # rest of file basename
ligand="water"                                         # ligand or coord complex name

touch ${working_dir}/${ligand}_${run}_jobs.txt
echo "source ${g16_rc}" > ${working_dir}/${ligand}_${run}_jobs.txt
### Setting up input files for gas phase opt with basis 1 ###
# for each line in element_list.txt
while IFS= read -r line; do
    #echo $line
    element=$(echo ${line} | awk '{ print $1 }' )      # use awk to get element
    multiplicity=$(echo ${line} | awk '{ print $2 }' ) # use awk to get multiplicity
    mkdir ${working_dir}/${element}
    cp ${template_dir}/${template} ${working_dir}/${element}/${element}_${ligand}_${run}.com
    # replace "XX" with element symbol
    sed -i "s+XX+${element}+g" ${working_dir}/${element}/${element}_${ligand}_${run}.com
    # replace "mult" with correct multiplicity
    sed -i "s+mult+${multiplicity}+g" ${working_dir}/${element}/${element}_${ligand}_${run}.com
    # append basis set to end of input file
    cat "${basis1_dir}/${element}_${basis1}.txt" >> "${working_dir}/${element}/${element}_${ligand}_${run}.com"
    # if using implicit solvent, make sure to add sphere radius info to end of file as well
    # write line for submitting job to ${ligand}_${run}_jobs.txt
    job_line="cd ${working_dir}/${element} ; nohup g16 ${element}_${ligand}_${run}.com > ${working_dir}/${element}/${element}_${ligand}_${run}.out &"
    echo "${job_line}" >> ${working_dir}/${ligand}_${run}_jobs.txt
done < element_list.txt

echo "Check spacing - Gaussian is particular."
echo "One line between structure and basis set info."
echo "Two lines after end of basis set info before end of file."

