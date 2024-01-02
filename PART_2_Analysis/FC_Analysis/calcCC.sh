#!/bin/bash

rtpath="/home/nikin/16E7-2E94/FinalYearProject/fc_analyis/roi_selection"
GMMaskPath="/home/nikin/16E7-2E94/FinalYearProject/preprocessed_data/CommonGM_Mask/CommonGMmask+tlrc."
atlas="/home/nikin/projects/functional_connectivity/fc_analysis/roi_selection/BNA_MPM_thr25_1.25mm+tlrc"
# atlas="/home/nikin/16E7-2E94/FinalYearProject/BNA_MPM_thr25_1.25mm+tlrc"


#subjest lists for HC 
# ARClist='0489 0491 0497 0506 0508 0510 0524 0526 0528 0544 0620 0645 0649 0652 0669'

#subjest lists for MDD
ARClist='0500 0502 0509 0515 0521 0523 0527 0533 0543 0545 0565 0575 1016 1020'

var=rest_errt; view=tlrc

ROIs='rHipp cHipp vCa dCa'

		#################################################
		# rHipp= rostal hippocampus, range=215-216        #
		# cHipp= caudal hippocampus, range=217-218        #
    # vCa= ventral caudate, range =219-220            #
		# dCa= dorsal caudate, range=227-228	          	#
		#################################################

# for item in ${ARClist}
# do
#   # rm /home/namrata/practice/ROI/MDD/${item}/${item}_rest_errt+tlrc.*
#   mkdir ${rtpath}/HC/ROI-${item}
#   cp -v /home/nikin/16E7-2E94/FinalYearProject/preprocessed_data/Covariates_Removed_data/HC/Covariates_removed-${item}/${item}_rest_errt+tlrc.* ${rtpath}/MDD/ROI-${item}
# done

#resample the common gray matter mask to prevent the error: incompatible dimensions
cd ${rtpath}

# rm -f resampled_CommonGMmask+tlrc*		
# 3dresample -master ${rtpath}/HC/ROI-0489/0489_rest_errt+tlrc \
#   -prefix resampled_CommonGMmask  -input ${GMMaskPath}

rm -f BNA_MPM_thr25_1.25mm+tlrc.*

#3dcalc -a BNA_MPM_thr25_1.25mm.nii -expr 'a' -prefix BNA_MPM_thr25_1.25mm
for s in ${ARClist}
do
	cd ${rtpath}/MDD/ROI-${s}  
	rm -f ${s}_BNA_Atlas_Mask+tlrc.*
	3dresample -master ${s}_rest_errt+tlrc -prefix ${s}_BNA_Atlas_Mask -input ${atlas}

  	for roi in ${ROIs}
  	do
  		if [ ${roi} = 'rHipp' ]
		then
			
    			3dmaskave -mask ${s}_BNA_Atlas_Mask+tlrc -quiet -mrange 215 216 ${s}_${var}+tlrc > ${s}_${roi}.1D
		elif [ ${roi} = 'cHipp' ]
		then
			
			3dmaskave -mask ${s}_BNA_Atlas_Mask+tlrc -quiet -mrange 217 218 ${s}_${var}+tlrc > ${s}_${roi}.1D

		elif [ ${roi} = 'vCa' ]
		then
			
			3dmaskave -mask ${s}_BNA_Atlas_Mask+tlrc -quiet -mrange 219 220 ${s}_${var}+tlrc > ${s}_${roi}.1D

		elif [ ${roi} = 'dCa' ]
		then
			
			3dmaskave -mask ${s}_BNA_Atlas_Mask+tlrc -quiet -mrange 227 228 ${s}_${var}+tlrc > ${s}_${roi}.1D
		fi
	
	rm -f ${s}_${roi}_cc+tlrc.*
	rm -f ${s}_${roi}_z+tlrc.*
	rm -f resampled_CommonGMmask+tlrc.*
	

	3dDeconvolve -input ${s}_rest_errt+tlrc \
	-mask /home/nikin/16E7-2E94/FinalYearProject/fc_analyis/roi_selection/resampled_CommonGMmask+tlrc \
 	-jobs 8 -float \
 	-GOFORIT 10 \
   	-num_stimts 1 \
    	-stim_file 1 ${s}_${roi}.1D \
    	-stim_label 1 "${s}" \
    	-tout -rout -bucket ${s}_buc
    	3dcalc -a ${s}_buc+tlrc'[4]' -b ${s}_buc+tlrc'[2]' \
    	-expr "ispositive(b)*sqrt(a)-isnegative(b)*sqrt(a)" -prefix ${s}_${roi}_cc
    	3dcalc -a ${s}_${roi}_cc+tlrc -expr "0.5*log((1+a)/(1-a))" -datum float -prefix ${s}_${roi}_z
    	rm -f ${s}_buc+tlrc.*
    	rm -f ${s}_${roi}.1D
	
	done
done		
