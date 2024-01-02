#!/bin/bash
ROI_Path="/home/nikin/16E7-2E94/FinalYearProject/fc_analyis/roi_selection"
ROIs='rHipp cHipp vCa dCa'
GMMaskPath="/home/nikin/16E7-2E94/FinalYearProject/fc_analyis/roi_selection/resampled_CommonGMmask+tlrc"
WORKING_DIRECTORY="/home/nikin/16E7-2E94/FinalYearProject/fc_analyis/group_Ttest"

# Within group T-test
cd ${WORKING_DIRECTORY}/Within/HC

for roi in ${ROIs}
do
 	rm -f HC_${roi}+tlrc*
	rm -f m_HC_${roi}+tlrc.*

	# one sample t-test for HC group 
	3dttest++ -prefix HC_${roi} -setA ${ROI_Path}/HC/ROI-0*/*_${roi}_z+tlrc.HEAD
	3dcalc -a HC_${roi}+tlrc -b ${GMMaskPath} -expr a*b -prefix m_HC_${roi}

done

cd ${WORKING_DIRECTORY}/Within/MDD

for roi in ${ROIs}
do
	rm -f MDD_${roi}+tlrc*
	rm -f m_MDD_${roi}+tlrc.*
	#one sample t-test for MDD group
  3dttest++ -prefix MDD_${roi} -setA ${ROI_Path}/MDD/ROI-[0-1]*/*_${roi}_z+tlrc.HEAD
  3dcalc -a MDD_${roi}+tlrc -b ${GMMaskPath} -expr a*b -prefix m_MDD_${roi}
 
done

 Between group T-test
cd ${WORKING_DIRECTORY}/Between/

for roi in ${ROIs}
do
	rm -f HC_vs_MDD_${roi}+tlrc.*
	rm -f m_HC_vs_MDD_${roi}+tlrc.*
	#group t test
  3dttest++ -prefix HC_vs_MDD_${roi} \
    -setA ${ROI_Path}/HC/ROI-0*/*_${roi}_z+tlrc.HEAD \
    -setB ${ROI_Path}/MDD/ROI-0*/*_${roi}_z+tlrc.HEAD

	3dcalc -a HC_vs_MDD_${roi}+tlrc -b ${GMMaskPath} \
    -expr a*b -prefix m_HC_vs_MDD_${roi}
done
