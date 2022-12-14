#!/bin/bash
# this script will estimate a phylogeny for a multiple sequence alignment
# usage: ./make_phylo align_file phylo_tool [phylo_tool_options]
# align_file is the slignment
# phylo tool is the indicated phylo program
# settings are held in phylo_tool_options
# must support FastTree
#		must support more complex model of nuecleotide evolution -gtr
#              IG-Tree
#		must support -m GTR or a simpler model -m JC
#              MPBoot
# invald input and/or invalid oftware options may cause the phylo to fail and this should be reported to warnings.log
# the script should write three files
#				1. output phylogenetic estimate as a Newick string
#					named as alignfile.phylo_phylotool.tre
#				2. a text rep of the phylo with NW Utilities
#					named as alignfile.phylo_phylotool.nw_display.≈txt
#				3. a log file that documents the phylogeneic inference settings
#					displayed as alignfile.phylo_phylotool.log
#					report name of the phylo with the Newisk
#						command string to infer the phylogeny
#						WHEN using date the phylo was created


align_file=$1
align_seqs=$(cat "./sequences/$align_file")
phylo_tool=$2
phylo_tool_options=$(cat "$3")
OUTGROUP=$4
date=$(date)
if [[ ! -n $OUTGROUP ]]
then
	OUTGROUP=$(cat "./sequences/$align_file" | head -n1 | tr -d ">")
fi
# echo $align_file; echo $align_seqs; echo $phylo_tool; echo $phylo_tool_options; echo $OUTGROUP

if [[ $phylo_tool = "FastTree" ]]
then
	if [[ ! -n $(find "./phylogenies/$align_file.phylo_fasttree.log") ]]
        then
                touch "./phylogenies/$align_file.phylo_fasttree.log"
        else
                rm "./phylogenies/$align_file.phylo_fasttree.log"
                touch "./phylogenies/$align_file.phylo_fasttree.log"
        fi

	complexity=$(echo "$phylo_tool_options" | grep "FastTree" | cut -d "," -f2 | cut -d "=" -f2)
	if [[ -n $complexity || -n $(cat "./sequences/$align_file") ]]
	then
		if [[ ! -n $(find "./phylogenies/$align_file.phylo_fasttree.tre") ]]
        	then
                	touch "./phylogenies/$align_file.phylo_fasttree.tre"
        	else
                	rm "./phylogenies/$align_file.phylo_fasttree.tre"
                	touch  "./phylogenies/$align_file.phylo_fasttree.tre"
        	fi
		echo "name and location of file: ./phylogenies/$align_file.phylo_fasttree.tre" >> "./phylogenies/$align_file.phylo_fasttree.log"
		if [[ $complexity = "complex" ]]
		then
			fasttree -nt -gtr -noml "./sequences/$align_file" >> "./phylogenies/$align_file.phylo_fasttree.tre"
			echo "command string: fasttree -nt -gtr -noml \"./sequences/$align_file\" >> \"./phylogenies/$align_file.phylo_fasttree.tre\"" >> "./phylogenies/$align_file.phylo_fasttree.log"
		else
			fasttree -gtr -noml "./sequences/$align_file" >> "./phylogenies/$align_file.phylo_fasttree.tre"
			echo "command string: fasttree -gtr -noml \"./sequences/$align_file\" >> \"./phylogenies/$align_file.phylo_fasttree.tre\"" >> "./phylogenies/$align_file.phylo_fasttree.log"
		fi
		echo "date the phylogeny was created: $date" >> "./phylogenies/$align_file.phylo_fasttree.log"
	else
		echo "warning: FastTree failed to run for $align_file"
		# print something to the warning log
	fi
fi

if [[ $phylo_tool = "IQ-Tree" ]] # I think I have the if, then, else, fi messed up FIX
then
	echo "check"

	if [[ ! -n $(find "./phylogenies/$align_file.phylo_IQ-Tree.log") ]]
        then
                touch "./phylogenies/$align_file.phylo_IQ-Tree.log"
        else
                rm "./phylogenies/$align_file.phylo_IQ-Tree.log"
                touch "./phylogenies/$align_file.phylo_IQ-Tree.log"
        fi
	complexity=$(echo "$phylo_tool_options" | grep "IQ-Tree" | cut -d "," -f2 | cut -d "=" -f2)
	if [[ -n $complexity || -n $(cat "./sequences/$align_file") ]]
	then
		if [[ ! -n $(cat "./phylogenies/$align_file.phylo_IQ-Tree.tre") ]]
        	then
                	touch "./phylogenies/$align_file.phylo_IQ-Tree.tre"
        	else
                	rm "./phylogenies/$align_file.phylo_IQ-Tree.tre"
                	touch  "./phylogenies/$align_file.phylo_IQ-Tree.tre"
        	fi
		if [[ -n $complexity || -n $(cat "./sequences/$align_file") ]]
		then
			echo "name and location of newick string file: ./phylogenies/$align_file.phylo_IQ-Tree.tre" >> "./phylogenies/$align_file.phylo_IQ-Tree.log"
			if [[ $complexity = "complex" ]]
			then
				iqtree -s $(cat "./sequences/$align_file") -m GTR JC+FQ -bb 1000 -o "$OUTGROUP" -pre "./phylogenies/$align_file.phylo_IQ-Tree.tre"
				echo "command string:  iqtree -s $(cat \"./sequences/$align_file\") -m GTR JC+FQ -bb 1000 -o \"$OUTGROUP\" -pre \"./phylogenies/$align_file.phylo_IQ-Tree.tre\"" >> "./phylogenies/$align_file.phylo_IQ-Tree.log"
			else
				iqtree -s $(cat "./sequences/$align_file") -m JC+FQ -bb 1000 -o "$OUTGROUP" -pre "./phylogenies/$align_file.phylo_IQ-Tree.tre"
				echo "iqtree -s $(cat \"./sequences/$align_file\") -m JC+FQ -bb 1000 -o \"$OUTGROUP\" -pre \"./phylogenies/$align_file.phylo_IQ-Tree.tre\"" >> "./phylogenies/$align_file.phylo_IQ-Tree.log"
			fi
		echo "date the phylogeny was created: $date" >> "./phylogenies/$align_file.phylo_IQ-Tree.log"
	else
		echo "warning: IQ-Tree failed to run for $align_file"
		#print something to the warning log
	fi
fi
exit
if [[ $phylo_tool = "MPBoot" ]] # change everything to MPBoot instead of IQ-Tree
then
	if [[ ! -n "./phylogenies/$align_file.phylo_MPBoot.log" ]]
        then
                touch "./phylogenies/$align_file.phylo_MPBoot.log"
        else
                rm "./phylogenies/$align_file.phylo_MPBoot.log"
                touch "./phylogenies/$align_file.phylo_MPBoot.log"
        fi
       # there are no settings for MPBoot
        if [[ -n "./sequences/$align_file" ]]
		if [[ ! -n $(cat "./phylogenies/$align_file.phylo_MPBoot.tre") ]]
        	then
			touch "./phylogenies/$align_file.phylo_MPBoot.tre"
                else
                        rm "./phylogenies/$align_file.phylo_MPBoot.tre"
                        touch  "./phylogenies/$align_file.phylo_MPBoot.tre"
                fi

                        echo "name and location of newick string file: ./phylogenies/$align_file.phylo_MPBoot.tre" >> "./phylogenies/$align_file.phylo_MPBoot.log"
		       	mpboot -s $(cat "./sequences/$align_file") -bb 1000 -o "$OUTGROUP" -pre "./phylogenies/$align_file.phylo_MPBoot.tre"
			echo "command string: mpboot -s $(cat \"./sequences/$align_file\" -bb 1000 -o \"$OUTGROUP\" -pre \"./phylogenies/$align_file.phylo_MPBoot.tre\"" >> "./phylogenies/$align_file.phylo_MPBoot.log"
                	echo "date the phylogeny was created: $date" >> "./phylogenies/$align_file.phylo_MPBoot.log"
        else
		echo "warning: MPBoot failed to run for $align_file" >> "./warning.log"
        fi
fi
