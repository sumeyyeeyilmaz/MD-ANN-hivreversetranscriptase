# Data:
Stanford_Data.xlsx: Stanford data for 10 RTIs (downloaded 22/02/2023).
External_Data.xlsx: ChEMBL-curated dataset. Refer to the manuscript for full details.
Final.mat: Includes, Stanford data for 10 RTIs (downloaded 22/02/2023) and external_data.xlsx (ChEMBL-curated dataset). Refer to the manuscript for full details.
Muts.mat: Contains unique mutations found in the Stanford dataset.
YPRED_5.mat: Contains training results obtained using 5-cv (result of MAIN.m)
foldIndexes.mat: Contains indices of 5-fold cv (result of MAIN.m).
YPRED.mat: Average estimates obtained as a result of cross-validation.
Morgan.mat: Representation of inhibitors for Stanford 10 RTIs.
Morgan1335.mat: Representation of inhibitors for ChEMBL database.

# Codes:
str_char_improved.m: This function converts the isolates into individual mutation patterns.
class_perform.mat: This file calculates classification metrics.
tan_sim.m: This file measures the angle between two vectors and expresses the similarity of the vectors based on this angle.
training.m : This file aims to conduct training using an ANN.
MAIN.m: This code generates predictions by cross-validating the external dataset and saves these predictions to a file. I
Create_YPRED.m: YPRED5 and foldIndexes.mat files are loaded. It assigns it to an array by rearranging and concatenating it, and then saves these predictions in the YPRED.mat file.
Code.m: This code contains a set of operations used to analyze the results by performing various operations on a data set.




