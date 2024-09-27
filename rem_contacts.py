import numpy as np
import math
import pandas as pd
import matplotlib.pyplot as plt

# This script is for organizing results from QM calculations of REM binding,
# procesing the optimized geometries to get distances between the ions and oxygens

#################################################

# function to find distances
# Python program to find distance between
# two points in 3 D.
def distance(ion_x, ion_y, ion_z, atom_x, atom_y, atom_z): 
    
    ion = [ion_x, ion_y, ion_z]
    atom = [atom_x, atom_y, atom_z]
    ion_dist = math.dist(ion, atom)
    
    return(ion_dist)

#################################################

element_list = ["La", "Ce", "Nd", "Sm", "Gd", "Tb", "Lu"] # "Yb",
pocket_list = ["8FNS","7CCO" ]
run_list = ["QM1" , "Suc" ] # "Ren" for 7CCO and "FNd" for 8FNS

for pocket in pocket_list:
    print(pocket)
    for run in run_list:
        for element in element_list:
            print(element)
            #print(f'{element}_{pocket}_{run}_contacts.txt')
            #txt = print(f'{element}_{pocket}_{run}_contacts.txt')
            df = pd.read_csv(f'{element}_{pocket}_{run}_contacts.txt', delim_whitespace=True)
            df["IonDist"] = ""
            # need to figure out how to do this for each element , pocket, run
            ion_row = df.loc[df['Element'] == element]
            ion_x = ion_row['X'].values[0]
            ion_y = ion_row['Y'].values[0]
            ion_z = ion_row['Z'].values[0]
            # for each atom, calculate distances
            for index, row in df.iterrows():
                atom_x = row['X']
                atom_y = row['Y']
                atom_z = row['Z']
                ion_dist = distance(ion_x, ion_y, ion_z, atom_x, atom_y, atom_z)
                print(ion_dist)
                df.at[index,'IonDist'] = ion_dist
            df.to_csv(f'{element}_{pocket}_{run}_distances.csv', index=False)

