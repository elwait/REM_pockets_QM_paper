#!/bin/bash


# Purpose:
# Prepare input for QM binding calculations (REMs coordinated by multiple molecules)
# Current version creates jobs for each element for single point calculations after opt
# Currently set up for just one job type at a time (such as all with PCM)
# Lines for job submission are written to a *sh file also

# Notes: 
# Start script in working dir (ex: /REM_pockets_QM_paper/QM_coordination/7CCO/sp_QM1/pcm/)
# Make sure to have element_mult_sph.txt (includes 3rd column with implicit solvent radii if using)
# Have template *.com input file

#B3LYP/6-31G* & def2-TZVP (ion) for gas-phase opt and PCM cal (PCM does not work with DKH )
#B3LYP/Sapporo-DKH3-TZVP (ion) & def2-TZVP for gas-phase singe point energy w/ relativistic effect; “int=DKH”


# Alter the following variables for your needs:
g16_rc="/home/usr/.g16.bashrc"
run="opt"                                              # rest of file basename
ligand="7CCO"                                          # ligand or coord complex name
working_dir="/REM_pockets_QM_paper/QM_coordination/7CCO/sp_QM1/pcm"          # need full path
template_dir="/REM_pockets_QM_paper/QM_coordination/7CCO/sp_QM1/pcm"         # need full path
template="SP_PCM_template.com"
# atomic symbol should be "XX" in the template file in coords and wherever else
# XX will be replaced with the atomic symbol
# multiplicity should also be represented by "mult" which will be replaced
# template should have everything you need to run except the element atomic symbol and basis set
#     OR if you need to add structure from XYZs for each element, have no lines in template after charge, mult line
#     and then uncomment the section for writing those to each element's input file


# Basis set names and paths to files if downloaded from Basis Set Exchange
# Have multiple here because I switch depending on calculation type
basis1="def2tzvp"
basis1_dir="/REM_pockets_QM_paper/QM_coordination/basis_sets/def2tzvp"       # need full path
# Example of basis set file name: Lu_def2tzvp.txt 
basis2="S-dkh3tzp"
basis2_dir="/REM_pockets_QM_paper/QM_coordination/basis_sets/sapporoDKH3TZP" # need full path
# Example of basis set file name: Lu_S-dkh3tzp.txt



touch ${working_dir}/${ligand}_${run}_jobs.txt
echo "source ${g16_rc}" > ${working_dir}/${ligand}_${run}_jobs.txt
### Setting up input files for gas phase opt with basis 1 ###
# for each line in element_list.txt
while IFS= read -r line; do
    #echo $line
    element=$(echo ${line} | awk '{ print $1 }' )      # use awk to get element
    multiplicity=$(echo ${line} | awk '{ print $2 }' ) # use awk to get multiplicity
    #radius=$(echo ${line} | awk '{ print $3 }' )       # use awk to get implicit solvent radii
    mkdir ${working_dir}/${element}
    cp ${template_dir}/${template} ${working_dir}/${element}/${element}_${ligand}_${run}.com
    # replace "XX" with element symbol
    sed -i "s+XX+${element}+g" ${working_dir}/${element}/${element}_${ligand}_${run}.com
    # replace "mult" with correct multiplicity
    sed -i "s+mult+${multiplicity}+g" ${working_dir}/${element}/${element}_${ligand}_${run}.com
    # Next section only necessary if structure and non-ion basis are not in template
    #cat /path/to/${element}_structure.xyz >> ${working_dir}/${element}/${element}_${ligand}_${run}.com
    #echo " " >> ${working_dir}/${element}/${element}_${ligand}_${run}.com
    #echo "H C O 0" >> ${working_dir}/${element}/${element}_${ligand}_${run}.com
    #echo "6-31G*" >> ${working_dir}/${element}/${element}_${ligand}_${run}.com
    #echo "****" >> ${working_dir}/${element}/${element}_${ligand}_${run}.com
    # append basis set for ion to end of input file
    cat "${basis1_dir}/${element}_${basis1}.txt" >> ${working_dir}/${element}/${element}_${ligand}_${run}.com
    echo " " >> ${working_dir}/${element}/${element}_${ligand}_${run}.com
    echo " " >> ${working_dir}/${element}/${element}_${ligand}_${run}.com
    # if need to modify sphere radius, add that info to end of file as well
    #echo "Modifysph" >> ${working_dir}/${element}/${element}_${ligand}_${run}.com
    #echo "${element} ${radius}" >> ${working_dir}/${element}/${element}_${ligand}_${run}.com
    # write line for submitting job to ${ligand}_${run}_jobs.txt
    #echo " " >> ${working_dir}/${element}/${element}_${ligand}_${run}.com
    #echo " " >> ${working_dir}/${element}/${element}_${ligand}_${run}.com
    job_line="cd ${working_dir}/${element} ; nohup g16 ${working_dir}/${element}/${element}_${ligand}_${run}.com > ${working_dir}/${element}/${element}_${ligand}_${run}.out &"
    echo "${job_line}" >> ${working_dir}/${ligand}_${run}_jobs.txt
done < element_mult_sph.txt

echo "Check spacing - Gaussian is particular."
echo "One line between structure and basis set info."
echo "Two lines after end of basis set info before end of file."

