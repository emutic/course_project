# course_project
This the repository for my course project in Biology 4220 Practical Bioinformatics.
The pipeline will be able to call 
./pipeline SETTINGS_FILE [optional JOB_DIR]
which takes a settings file as input and the optional name of a job directory to save output into
Then, the pipeline.sh will run 7 other files in a general order:
1. Parse settings
2. Gather sequences
3. Align sequences
4. Estimate phylogenetic tree from alignment
5. Characterize variation in molecular alignmnet
6. Test for signatures of positive selection
7. Generate output files
# pipeline schematic
# (order of steps)
                 
                  + → 6 ──+
                  |   ↓   ↓
 in → 1 → 2 → 3 → 4 → 7 → out
                  |       ↑
                  + → 5 ──+ 
then, I will add two custom features
