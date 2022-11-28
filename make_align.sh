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
	muscle -in ./$sequence_dir/all_sequences  -out "./$sequence_dir/$sequence_dir.align_muscle.fasta" -maxiters $maxiters
	if [[ ! -n $(cat "./$sequence_dir/$sequence_dir.align_muscle.fasta") ]]
        then
                echo "warning: muscle failed to align all sequences in the directory $sequence_dir" >> "./warnings.log"
                continue
        fi
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
	echo "command string: muscle -in ./$sequence_dir/all_sequences  -out \"./$sequence_dir/$sequence_dir.align_muscle.fasta\" -maxiters 1" >> "./$sequence_dir/$sequence_dir.align_muscle.log"
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
        op=$(echo "$align_tool_options" | grep "MAFFT" | cut -d "," -f2 | cut -d "=" -f2)
	ep=$(echo "$align_tool_options" | grep "MAFFT" | cut -d "," -f3 | cut -d "=" -f2)
	if [[ ! -n $(cat "./$sequence_dir/$sequence_dir.align_MAFFT.fasta") ]]
        then
                echo "making output file"
                touch "./$sequence_dir/$sequence_dir.align_MAFFT.fasta"
        else
                echo "resetting output file"
                rm "./$sequence_dir/$sequence_dir.align_MAFFT.fasta"
                touch "./$sequence_dir/$sequence_dir.align_MAFFT.fasta"
        fi

        mafft --op $op --ep $ep "./$sequence_dir/all_sequences" > "./$sequence_dir/$sequence_dir.align_MAFFT.fasta"
        if [[ ! -n $(cat "./$sequence_dir/$sequence_dir.align_MAFFT.fasta") ]]
        then
                echo "warning: MAFFT failed to align all sequences in the directory $sequence_dir" >> "./warnings.log"
                continue
        fi

	if [[ ! -n $(cat "./$sequence_dir/$sequence_dir.align_MAFFT.log") ]]
        then
                echo "making alignment settings file"
                touch "./$sequence_dir/$sequence_dir.align_MAFFT.log"
        else
                echo "resetting the log file"
                rm "./$sequence_dir/$sequence_dir.align_MAFFT.log"
                touch "./$sequence_dir/$sequence_dir.align_MAFFT.log"
        fi

        echo "alignment file name: $sequence_dir.align_MAFFT.fasta" >> "./$sequence_dir/$sequence_dir.align_MAFFT.log"
        echo "command string: mafft --op $op --ep $ep \"./$sequence_dir/all_sequences\" > \"./$sequence_dir/$sequence_dir.align_MAFFT.fasta\"" >> "./$sequence_dir/$sequence_dir.align_MAFFT.log"
        date=$(date)
        echo "alignment was created on $date" >> "./$sequence_dir/$sequence_dir.align_MAFFT.log"
        num_seq=$(cat "./$sequence_dir/all_sequences" | grep ">" | wc -l)
        num_sites=$(cat "$sequence_dir/$sequence_dir.align_MAFFT.fasta" | grep -v ">" | wc -c)
        num_sites=$(($num_sites/$num_seq))
        echo "number of sequences aligned: $num_seq" >> "./$sequence_dir/$sequence_dir.align_MAFFT.log"
        echo "number of sites aligned: $num_sites" >> "./$sequence_dir/$sequence_dir.align_MAFFT.log"
        echo "$align_tool_options" | grep "MAFFT" >> "./$sequence_dir/$sequence_dir.align_MAFFT.log"

fi

if [[ $align_tool = "PRANK" ]]
then
	echo "running PRANK"
        gaprate=$(echo "$align_tool_options" | grep "PRANK" | cut -d "," -f2 | cut -d "=" -f2)
        gapext=$(echo "$align_tool_options" | grep "PRANK" | cut -d "," -f3 | cut -d "=" -f2)
	if [[ ! -n $(cat "./$sequence_dir/$sequence_dir.align_PRANK.fasta") ]]
        then
                echo "making output file"
                touch "./$sequence_dir/$sequence_dir.align_PRANK.fasta"
        else
                echo "resetting output file"
                rm "./$sequence_dir/$sequence_dir.align_PRANK.fasta"
                touch "./$sequence_dir/$sequence_dir.align_PRANK.fasta"
        fi
	prank -gaprate="$gaprate" -gapext="$gapext" -d="./$sequence_dir/all_sequences" -o="./$sequence_dir/$sequence_dir.align_PRANK.fasta"; cp "./$sequence_dir/$sequence_dir.align_PRANK.fasta.best.fas" "./$sequence_dir/$sequence_dir.align_PRANK.fasta"; rm "./$sequence_dir/$sequence_dir.align_PRANK.fasta.best.fas"
	if [[ ! -n $(cat "./$sequence_dir/$sequence_dir.align_PRANK.fasta") ]]
        then
                echo "warning: PRANK failed to align all sequences in the directory $sequence_dir" >> "./warnings.log"
		continue
        fi

        if [[ ! -n $(cat "./$sequence_dir/$sequence_dir.align_PRANK.log") ]]
        then
                echo "making alignment settings file"
                touch "./$sequence_dir/$sequence_dir.align_PRANK.log"
        else
                echo "resetting the log file"
                rm "./$sequence_dir/$sequence_dir.align_PRANK.log"
                touch "./$sequence_dir/$sequence_dir.align_PRANK.log"
        fi


        echo "alignment file name: $sequence_dir.align_PRANK.fasta" >> "./$sequence_dir/$sequence_dir.align_PRANK.log"
        echo "command string: prank -gaprate=\"$gaprate\" -gapext=\"$gapext\" -d=\"./$sequence_dir/all_sequences\" -o=\"./$sequence_dir/$sequence_dir.align_PRANK.fasta\"; cp \"./$sequence_dir/$sequence_dir.align_PRANK.fasta\"; rm \"./$sequence_dir/$sequence_dir.align_PRANK.fasta.best.fas\"" >> "./$sequence_dir/$sequence_dir.align_PRANK.log"
        date=$(date)
        echo "alignment was created on $date" >> "./$sequence_dir/$sequence_dir.align_PRANK.log"
        num_seq=$(cat "./$sequence_dir/all_sequences" | grep ">" | wc -l)
        num_sites=$(cat "$sequence_dir/$sequence_dir.align_PRANK.fasta" | grep -v ">" | wc -c)
        num_sites=$(($num_sites/$num_seq))
        echo "number of sequences aligned: $num_seq" >> "./$sequence_dir/$sequence_dir.align_PRANK.log"
        echo "number of sites aligned: $num_sites" >> "./$sequence_dir/$sequence_dir.align_PRANK.log"
        echo "$align_tool_options" | grep "PRANK" >> "./$sequence_dir/$sequence_dir.align_PRANK.log"


fi
