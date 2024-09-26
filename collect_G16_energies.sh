#!/bin/bash


# Author:
# Elizabeth E. Wait
#     University of Texas at Austin
#     Dr. Pengyu Ren's group
# 2024

# Purpose:
# Collect energies from QM calculations into a .csv
# Intended for combinding all energies from opt (thermal correction)
#     single point in gas (higher basis set)
#     single point no pcm (same basis set as opt)
#     single point with pcm (same basis set as opt)

# Notes:
# This is for all the ions with the same coordination complex
# Example: all ions with 7CCO (or 8FNS or water)
# This is done for each set of calculations (or "run", such as QM1 or successive)
# Must have G16 installed and set up
# Must have element_list.txt


G16_bashrc="/home/user/.g16.bashrc"                     # path to your G16 bashrc, see their instructions
ligand="7CCO"                                           # ligand or coordination complex
run="QM1"

working_dir="/REM_pockets_QM_paper/QM_coordination"    # parent dir containing opt dirs for each element
opt_dir="${working_dir}/7CCO/opt_QM1"
sp_pcm_dir="${working_dir}/7CCO/sp_QM1/pcm"
sp_gas_dir="${working_dir}/7CCO/sp_QM1/gas"
sp_nopcm_dir="${working_dir}/7CCO/sp_QM1/no_pcm"

touch ${ligand}_results_${run}.csv
echo 'Element,SP PCM 1,SP PCM 2,SP No PCM 1, SP No PCM 2,SP Gas 1,SP Gas 2,Thermal Corr Gibbs FE' > ${ligand}_results_${run}.csv

while IFS= read -r line; do
    element=$(echo ${line} | awk '{ print $1 }' ) # use awk to grab 1st part of line
    echo $element
    # collect energies from gaussian output for each element
    sp_pcm_energy_full=$(grep "SCF Done" ${sp_pcm_dir}/${element}/${element}_sp_pcm_FrmNd.log | awk '{ print $5 }' | tr -d ' ' | tr -d '\n' )
    # sometimes there are 2 values so I will include both
    sp_pcm_energy_1=$(echo ${sp_pcm_energy_full} | awk '{ print $1 }' | tr -d ' ' | tr -d '\n' )
    sp_pcm_energy_2=$(echo ${sp_pcm_energy_full} | awk '{ print $2 }' | tr -d ' ' | tr -d '\n' )
    sp_nopcm_energy_full=$(grep "SCF Done" ${sp_nopcm_dir}/${element}/${element}_sp_nopcm_FrmNd.log | awk '{ print $5 }' | tr -d ' ' | tr -d '\n' )
    sp_nopcm_energy_1=$(echo ${sp_nopcm_energy_full} | awk '{ print $1 }' | tr -d ' ' | tr -d '\n' )
    sp_nopcm_energy_2=$(echo ${sp_nopcm_energy_full} | awk '{ print $2 }' | tr -d ' ' | tr -d '\n' )
    sp_gas_energy_full=$(grep "SCF Done" ${sp_gas_dir}/${element}/${element}_sp_gas_FrmNd.log  | awk '{ print $5 }' | tr -d ' ' | tr -d '\n' )
    sp_gas_energy_1=$(echo ${sp_gas_energy_full} | awk '{ print $1 }' | tr -d ' ' | tr -d '\n' )
    sp_gas_energy_2=$(echo ${sp_gas_energy_full} | awk '{ print $2 }' | tr -d ' ' | tr -d '\n' )
    zp_corr=$(grep "Zero-point correction=" ${opt_dir}/${element}/${element}_FrmNd_8FNS_opt.log | awk '{ print $3 }' | tr -d ' ' | tr -d '\n' )
    therm_corr_ener=$(grep "Thermal correction to Energy=" ${opt_dir}/${element}/${element}_FrmNd_8FNS_opt.log | awk '{ print $5 }' | tr -d ' ' | tr -d '\n' )
    therm_corr_gib=$(grep "Thermal correction to Gibbs Free Energy=" ${opt_dir}/${element}/${element}_FrmNd_8FNS_opt.log | awk '{ print $7 }' | tr -d ' ' | tr -d '\n' )
    sum_ele_zpe=$(grep "Sum of electronic and zero-point Energies=" ${opt_dir}/${element}/${element}_FrmNd_8FNS_opt.log | awk '{ print $7 }' | tr -d ' ' | tr -d '\n' )
    sum_ele_therm_ener=$(grep "Sum of electronic and thermal Energies=" ${opt_dir}/${element}/${element}_FrmNd_8FNS_opt.log | awk '{ print $7 }' | tr -d ' ' | tr -d '\n' )
    sum_ele_therm_enth=$(grep "Sum of electronic and thermal Enthalpies=" ${opt_dir}/${element}/${element}_FrmNd_8FNS_opt.log | awk '{ print $7 }' | tr -d ' ' | tr -d '\n' )
    sum_ele_therm_fe=$(grep "Sum of electronic and thermal Free Energies=" ${opt_dir}/${element}/${element}_FrmNd_8FNS_opt.log | awk '{ print $8 }' | tr -d ' ' | tr -d '\n' )
    # write results for this element into ${ligand}_results_${run}.csv
    echo "${element},${sp_pcm_energy_1},${sp_pcm_energy_2},${sp_nopcm_energy_1},${sp_nopcm_energy_2},${sp_gas_energy_1},${sp_gas_energy_2},${therm_corr_gib}" >> ${ligand}_results_${run}.csv
done < element_list.txt

