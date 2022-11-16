#!/bin/bash

# this script will parse the settings file provided to the pipline. Therefore, the provided arguments are the path to the pipeline
# usage is ./parse_settings.sh SETTINGS_FILE PIPELINE_STEP

# in the settings: comma separated values in the format:
# script,settings
# get_seq.sh,accession=my_accessions.txt;sequence_dir=US_samples;overwrite=true;
# make_align.sh,sequence_dir=US_samples;align_tool=mafft;align_tool_options='-gapopen 2';
# make_phylo.sh,align_file=covid_align_mafft.fasta;phylo_tool=fasttree;phylo_tool_options='-gtr';
# make_mol_stats.py,align_file=covid_align_mafft.fasta;
# make_dnds.py,align_file=covid_align_mafft.fasta;phylo_file=covid_align_mafft_fasttree.tre;
# make_results.py,sequence_dir=US_samples;
# feature1.sh,setting1=my_feature1_settings.txt;parameter1=20;
# feature2.py,setting2=my_feature2_settings.txt;parameter2=50;

path=$1
step=$2

settings_list=$(grep $2 $1 | cut -d ',' -f2)

# parse the settings as need ?? they might provide all or none of the settings needed
echo ${settings_list}
echo 'hello world'
# what should the output be? 
