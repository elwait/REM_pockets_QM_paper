#!/bin/bash

# Author:
# Elizabeth E. Wait
#     University of Texas at Austin
#     Dr. Pengyu Ren's group
# 2024

# Purpose:
# Collect Energy Decomposition Analysis (EDA) Results from QChem output files
# Put results in comma delimited *.csv
# Intended for various lanthanides interacting with one small molecule ligand

# Notes:
# Start script in dir EDA was run in
#     File naming convention is ${Element}-${ligand}_eda.*
#     If using REM_pockets_QM_paper data, this would be in /EDA/acetate/decomp
# Make sure element_list.txt is present in 
#     Element_list has ion element and multiplicity (at 3+ charge)


dir=$PWD
element_list="${dir}/element_list.txt"
ligand="acetate" # what ion is interacting with

touch ${dir}/EDA_${ligand}_results.csv
echo "Element,Electrostatic,Ele Pauli,Dispersion,Repulsion,Polarization,Charge Transfer,Total" > ${dir}/EDA_${ligand}_results.csv
while IFS= read -r line; do
    echo $line
    Element=$(echo ${line} | awk '{ print $1 }' )
    Electrostatic=$(grep "E_cls_elec  (CLS ELEC)" ${Element}-${ligand}_eda.out | awk '{ print $6 }' )
    Ele_Pauli=$(grep "ELEC + PAULI = " ${Element}-${ligand}_eda.out | awk '{ print $5 }' | sed 's/,/ /g')
    Dispersion=$(grep "E_cls_disp  (CLS DISP)" ${Element}-${ligand}_eda.out | awk '{ print $6 }' )
    Repulsion=$(grep "E_mod_pauli (MOD PAULI)" ${Element}-${ligand}_eda.out | awk '{ print $6 }' )
    Polarization=$(grep "POLARIZATION" ${Element}-${ligand}_eda.out | awk '{ print $2 }' )
    Charge_Transfer=$(grep "CHARGE TRANSFER" ${Element}-${ligand}_eda.out | awk '{ print $3 }' )
    Total=$(grep " TOTAL " ${Element}-${ligand}_eda.out | awk '{ print $2 }' )
    echo "${Element},${Electrostatic},${Ele_Pauli},${Dispersion},${Repulsion},${Polarization},${Charge_Transfer},${Total}" >> ${dir}/EDA_${ligand}_results.csv
done < "${element_list}"
