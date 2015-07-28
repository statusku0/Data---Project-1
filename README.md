# Data---Project-1
Note: I analyzed 70 out of the 112 intermediate teeth branches on the MST (Each branch takes ~17 hrs to get results for).
-----------------------------------------------------
# Accessing/Displaying Results:
  To look at results for a single branch:
    Use the function, AnalyzingNumDensityRslts.m (NumDensity = number of points used for calculating cPdist between teeth)
    (for instance, to analyze the branch between tooth 'a10' and 'a13', run
        AnalyzingNumDensityRslts('a10','a13','linear','on','keep')
    )
    (in the figure that mentions r^2, I meant that I found the NumDensity that, for that NumDensity, when I plotted the number of intermediate teeth 
    against the LMSE ratio ((LMSE over branch with intermediate teeth) / (LMSE over branch without intermediate teeth)) and fitted a linear model to it, had the best r^2 value.
  
  To look at results for multiple branches:
    (If new data for new branches are added, update everything with AnalyzingcPdistRelationships.m)
    Run FitRatio.m (which, additionally, for the final plot, eliminates outliers and points that correspond to r^2 values less than 0.7)
    MyCoefs corresponds to the coefficients in the model I used to fit that data to 
    (Model eqn ->  y = -(MyCoefs(1)./(MyCoefs(2).*((x).^(MyCoefs(4)))))+MyCoefs(3))
    
-----------------------------------------------------

# Process I took to get Results:
1. Transfer meshes, landmarks, and taxa codes to the grid (I ran CollectArtiTeeth.m with the original intermediate teeth data given to me) 
(CollectArtiTeeth.m also renames all .off files to _sas.off files for consistency)
2. Generate the teeth samples on the grid
3. Run cluster_testingbranch.m (adjust line 57 to change which teeth branches I run the script for) and the results get sent to the Rslts folder, which has multiple Rslts folders 
that correspond to a specific branch (for instance, Rslts/rslts_a10_a13))
4. Transfer new branch results to NumDensityRslts on my local drive
  How things are structured in NumDensityRslts:
    -There are 112 folders in NumDensityRslts, each named according to the branch it represents.
    -Example: looking at a10_a13 branch, I can look inside the rslts_a10_a13 folder, and see 10 .mat files. Each .mat file has just one entry in a 
    1x10 cell corresponding the number of intermediate teeth. For instance, rslt_mat_1.mat just has the first entry filled, and that entry is a 
    1x39 cell, where each cell corresponds to a NumDensity used (So the first cell corresponds to NumDensity = 100, while the last one correponds to
    NumDensity = 2000). Inside each cell is a 1x2 matrix, where the first entry is the LMSE along the non-intermediate teeth branch, while the second entry is the LMSE along the intermediate teeth branch.
5. Run AnalyzingcPdistRelationships.m to update all branches to include new results.



