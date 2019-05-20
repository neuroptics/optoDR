# optoDR
A collection of scripts and functions for performing and analyzing optogenetic dose-response curve experiments, written in MATLAB.

Copyright (C) 2019 David Klorig
Author: David Klorig
Last modification: 5/20/2019


Required version of MATLAB and toolboxes

MATLAB v. 9.4 or greater
Signal Processing Toolbox v. 8.0 or greater
Statistics and Machine Learning Toolbox v. 11.3	or greater

Other Requirements

export_fig.m 
https://www.mathworks.com/matlabcentral/fileexchange/23629-export-fig
http://undocumentedmatlab.com/blog/export_fig


Description

This script and the associated functions import and analyze optogenetic dose-response data. The raw data was acquired using SciWorks DataWave. Stimulus control can also be performed in matlab with an appropriate AIO device.  The stimulus structure of the example consists of blocks of 20 intensity levels, presented in random order with a stimulus interval of 3s. The blocks are repeated for 60 reps. The recording array consists of 8 chs. The sampling rate of the original recordings is 40 kHz. A pulse alignment channel is used to precisely mark the timing of the stimulus. The stimulus order is saved in a list. 
All of the file parameters are specified in a spreadsheet called a “manifest” which is then imported as a structure in matlab. This is convenient way to store all of the information about each file required for analysis as well as experiment “tags” that allow sub-datasets to be created. To change analysis settings, just edit the spreadsheet and reload it. While this seems like a cumbersome solution for a single file, it is very helpful when working with large datasets. An example manifest is included in excel format (.xlxs).

To use:
1. Add folder "optoDR_for_eNeuro" and subfolders to the path.
2. Open "RUN_optoDR_analysis".
3. Change "extract_path" to match the location of the folder, save.
4. Hit "Run" button or run each section by highlighting and pressing "ctrl+enter".


The following functions are included, along with all other dependencies:

optoDRimport.m and NS_import_optoDR_sort_dec_list.m

These functions use the open-source neuroscience data standard NeuroShare (http://neuroshare.sourceforge.net/index.shtml) to import raw data. Stimulus timing pulses are detected and 200 ms epochs (50ms pre, 150 ms post) are extracted and decimated to a sampling rate of 4000 hz. The stimulus order list is used to sort the data and then store it in a cell array with the format “wave{chs,levels}(epoch,reps)”. The chronological order of the replicate blocks is preserved. The data is then bandpass filtered (5-300hz) and saved along with the wideband data in a .mat file for further analysis. The example data is provided in this format (significantly smaller than the original raw file). 

DR_average_and_SE_sorted.m

This function calculates the average of each channel and level with 95% confidence intervals.

DR_spike_RMS_calc.m

This function calculates the sliding window root-mean-squared (RMS) of the 2nd derivative of the bandpass filtered data.

DR_spike_sep_all_ch.m

This function detects and separates discharges from subthreshold responses.

DR_spike_curve_fit.m

This function uses the built-in MATLAB function NonLinearModel.fit.m to fit a curve to the data (entire session).

DR_spike_curve_fit_bin.m

This function uses the built-in MATLAB function NonLinearModel.fit.m to fit a curve to the data (binned data).



Complete List of Dependencies (third-party functions will be properly credited for the final release)

ciplot2.m                         
mexprog.mexw64                    
optoDR_import.m                   
copyfig.m                         
myColorMap.m                      
pdf2eps.m                         
DR_average_and_SE_sorted.m        
eps2pdf.m                        
norm_curve.m                      
pdftops.m                         
DR_filter_butter_bandpass.m       
export_fig.m                      
ns_CloseFile.m                    
predict.m                         
DR_plot_butterfly_all_ci.m        
fastrms.m                         
ns_GetAnalogData.m                
print2array.m                     
DR_spike_RMS_calc.m               
fix_lines.m                       
ns_GetEntityInfo.m                
print2eps.m                       
DR_spike_curve_fit.m              
ghostscript.m                     
ns_GetEventData.m                 
user_string.m                     
DR_spike_curve_fit_bin.m          
isolate_axes.m                    
ns_GetFileInfo.m                  
DR_spike_sep_all_ch.m             
manual_subplot_tight.m            
ns_OpenFile.m                     
NS_import_optoDR_sort_dec_list.m  manual_subplot_tight2.m           
ns_SetLibrary.m                   
