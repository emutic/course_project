#!/bin/bash

# take the arguments $1 SEQUENCE_DIR
		   # $2 ALIGN_TOOL
		   # [ALIGN_TOOL_OPTIONS]
		   #	input argument
		   #	output argument
                   #    Muscle gap open penalty -gapopen
		   #	MAFFT gap open penalty --op and gap extension penalty -ep
                   #    PRANK gap open rate -gaprate and gap extension penalty -gapext
# this script will algign the sequences in sequence dir using the method align tool using the settins provided in align tool options
# concatenate all fasta files in sequence dir and take this as input for the alignment procedure

sequence_dir=$1
align_tool=$2
align_tool_options=$(cat "$3")


touch "./$sequence_dir/all_sequences"
for sequence in $(ls $sequence_dir)
do
	continue
	cat "./$sequence_dir/$sequence" >> "./$sequence_dir/all_sequences"
done

# then align the sequences using the supported alignment tool specified by align tool
# supported tools = Muscle, MAFFT, PRANK
# write two file outputs 1. the output alignment file named sequencedir.align_ALIGNTOOL.fasta
#			 2. the log file that documents the alignment settings named sequencedir.align_ALIGNTOOL.log

if [[ $align_tool = "Muscle" ]]
then
	echo "running muscle"
	maxiters=$(echo "$align_tool_options" | grep "Muscle" | cut -d "," -f2 | cut -d "=" -f2)
	if [[ ! -n $(cat "./$sequence_dir/$sequence_dir.align_muscle.fasta") ]]
	then
		echo "making output file"
		touch "./$sequence_dir/$sequence_dir.align_muscle.fasta"
	else
		echo "resetting output file"
		rm "./$sequence_dir/$sequence_dir.align_muscle.fasta"
		touch "./$sequence_dir/$sequence_dir.align_muscle.fasta"
	fi
	muscle -in ./$sequence_dir/all_sequences  -out "./$sequence_dir/$sequence_dir.align_muscle.fasta" -maxiters 1
	if [[ ! -n $(cat "./$sequence_dir/$sequence_dir.align_muscle.log") ]]
	then
		echo "making alignment settings file"
		touch "./$sequence_dir/$sequence_dir.align_muscle.log"
	else
		echo "resetting the log file"
		rm "./$sequence_dir/$sequence_dir.align_muscle.log"
		touch "./$sequence_dir/$sequence_dir.align_muscle.log"
	fi
	echo "alignment file name: $sequence_dir.align_muscle.fasta" >> "./$sequence_dir/$sequence_dir.align_muscle.log"
	echo "command string: muscle -in ./$sequence_dir/all_sequences  -out './$sequence_dir/$sequence_dir.align_muscle.fasta' -maxiters 1" >> "./$sequence_dir/$sequence_dir.align_muscle.log"
	date=$(date)
	echo "alignment was created on $date" >> "./$sequence_dir/$sequence_dir.align_muscle.log"
	num_seq=$(cat "./$sequence_dir/all_sequences" | grep ">" | wc -l)
	num_sites=$(cat "$sequence_dir/$sequence_dir.align_muscle.fasta" | grep -v ">" | wc -c)
	num_sites=$(($num_sites/$num_seq))
	echo "number of sequences aligned: $num_seq" >> "./$sequence_dir/$sequence_dir.align_muscle.log"
	echo "number of sites aligned: $num_sites" >> "./$sequence_dir/$sequence_dir.align_muscle.log"
	echo "$align_tool_options" | grep "Muscle" >> "./$sequence_dir/$sequence_dir.align_muscle.log"
fi

if [[ $align_tool = "MAFFT" ]]
then
        echo "running MAFFT"
	echo "running muscle"
        maxiters=$(echo "$align_tool_options" | grep "Muscle" | cut -d "," -f2 | cut -d "=" -f2)
        if [[ ! -n $(cat "./$sequence_dir/$sequence_dir.align_muscle.fasta") ]]
        then
                echo "making output file"
                touch "./$sequence_dir/$sequence_dir.align_muscle.fasta"
        else
                echo "resetting output file"
                rm "./$sequence_dir/$sequence_dir.align_muscle.fasta"
                touch "./$sequence_dir/$sequence_dir.align_muscle.fasta"
        fi
        muscle -in ./$sequence_dir/all_sequences  -out "./$sequence_dir/$sequence_dir.align_muscle.fasta" -maxiters 1
        if [[ ! -n $(cat "./$sequence_dir/$sequence_dir.align_muscle.log") ]]
        then
                echo "making alignment settings file"
                touch "./$sequence_dir/$sequence_dir.align_muscle.log"
        else
                echo "resetting the log file"
                rm "./$sequence_dir/$sequence_dir.align_muscle.log"
                touch "./$sequence_dir/$sequence_dir.align_muscle.log"
        fi
        echo "alignment file name: $sequence_dir.align_muscle.fasta" >> "./$sequence_dir/$sequence_dir.align_muscle.log"
        echo "command string: muscle -in ./$sequence_dir/all_sequences  -out './$sequence_dir/$sequence_dir.align_muscle.fasta' -maxiters 1" >> >
        date=$(date)
        echo "alignment was created on $date" >> "./$sequence_dir/$sequence_dir.align_muscle.log"
        num_seq=$(cat "./$sequence_dir/all_sequences" | grep ">" | wc -l)
        num_sites=$(cat "$sequence_dir/$sequence_dir.align_muscle.fasta" | grep -v ">" | wc -c)
        num_sites=$(($num_sites/$num_seq))
        echo "number of sequences aligned: $num_seq" >> "./$sequence_dir/$sequence_dir.align_muscle.log"
        echo "number of sites aligned: $num_sites" >> "./$sequence_dir/$sequence_dir.align_muscle.log"
        echo "$align_tool_options" | grep "Muscle" >> "./$sequence_dir/$sequence_dir.align_muscle.log"

fi

if [[ $align_tool = "PRANK" ]]
then
        echo "PRANK detected"
fi
