# PDW-perturbations

## Purpose
In this repository are all the files used to generate and analyze the data 
presented in `Dynamic Stability of Passive Dynamic Walking Following Unexpected Perturbations`. 

## Data Generation 
The main files in this folder are `perturb_pdw.m` and `collect_data.m,` which 
encompass the data generating and synthesizing process. `heatmap_loop.m`
is also a useful data generating function.

`collect_data.m` saves data into the 
PDW-perturbations/Data directory, within a folder named, for example,
`Data_n50000g0.014p0.5d03-Jun22`. Where the number after `n` is the number
of fall or nonfall trials completed (not counting early falls), the number 
after `g` is the gamma value in radians, the number after `p` is 
the perturbation size (referred to as $\delta$ in the manuscript), and the
values after `d` are the day number the data was saved followed by the month and year.
Details of the saved files are in the code documentation.

`heatmap_loop.m` saves two data sets into a folder in PDW-perturbations/Data
titled, for example, `HeatmapData_n20000g0.014_0.019p0.02_0.5d01-Jun22`.
The gamma and perturbation ranges are shown after `g` and `p`, respectively.
Details of the saved files are in the code documentation.

### :warning: NOTE:
Data generation takes a **LONG** time. This most likely can be improved, 
but ultimately is a fundamental component of the model given the very low percent yields
at high perturbation magnitudes. Before generating large amounts of data, 
experiment with the speed on your machine and familiarize yourself with the approximate time
smaller trial numbers take. 

## Analysis
The main files in this folder are `pert_percent_histograms.m`,
 `fall_step_histogram.m`, `linear_classify_processing.m`,
 `kinematics_compare.m`, and `heatmap_grey.m`. 
These were the files used to create the figures included in the manuscript. 
The other files are either auxilliary functions for those previously mentioned
or other pieces of analysis. The data files loaded in these are shown as an example of
what data each script is able to process.

## Brewermap colors
This folder is copied from the GitHub repository [DrosteEffect/BrewerMap](https://github.com/DrosteEffect/BrewerMap) to assist in creating quality figures.

## Contribution note
Since the purpose of this repository is to house the code described in the paper, no substantial modifications are needed. 
Performance and UI improvements are welcome to be submitted through a PR. 
