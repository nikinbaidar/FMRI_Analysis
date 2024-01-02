rtpath='/media/namrata/16E7-2E94/FinalYearProject/fc_analyis/group_Ttest/Between'
ROIs='rHipp cHipp vCa dCa'
th1=2.0555
cluster_threshold= 600

cd ${rtpath}

for roi in ${ROIs}
do
	rm -f M_HC_vs_MDD_${roi}_Clust_Mask
	3dclust -1Dformat -nosum -1dindex 1 -1tindex 1 -1thresh 2.0555  -dxyz=1 -savemask M_HC_vs_MDD_${roi}_Clust_Mask 1.01 600 m_HC_vs_MDD_${roi}+tlrc
done 

