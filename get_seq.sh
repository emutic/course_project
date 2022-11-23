#!/bin/bash


# gets fasta-formatted accessions from GenBank
# accepts two arguments. $1 is a list of accessions
# and a directory where the sequences are managed
# ./get_seq ACCESSION_FILE SEQUENCE_DIR [OVERWRITE]
accessions=$1
dir=$2


# check if the accession has been downloaded into the managed directory
# download any missing sequences and append any issues to the file
# warnings.log
dir_list=$(ls $2)
for accession in $(cat $1) # for loop iterate over each line (accession number) in the accessions file
do # do
# this will mark files to be downloaded
	if [[ $3 = "true" ]]
	then
		rm "./$dir/$accession.fasta" # exists but is invalid
		Seq=$(esearch -db nucleotide -query "$accession" | efetch -format fasta -stop 1)
		touch "./$dir/$accession.fasta"
		echo "Overriding sequence $accession"
		echo "$Seq" > "./$dir/$accession.fasta"
		# then download i
		continue
	fi
	accession_test=$(ls "$dir" | grep -o "$accession")
	if [[ -n $accession_test ]] # if [[ seq in dir
	then
		line1=$(cat "$dir/$accession_test.fasta" | grep -o ">$accession" | tr -d [:space:])
		line2=$(cat "$dir/$accession_test.fasta" | head -n2 | tail -n1 | grep -P ".*[AGCT].*" | tr -d [:space:])
		echo $line1 | wc -c
		echo $line2 | wc -c
		if [[ $(echo $line1 | wc -c) -gt 1 && $(echo $line2 | wc -c) -ge 2 ]]
		then
			echo "sequence $accession valid and downloaded"
			continue # exists and is valid
		else
			echo "sequence $accession not valid, overriding"
			rm "./$dir/$accession.fasta" # exists but is invalid
			# then download it
			Seq=$(esearch -db nucleotide -query "$accession" | efetch -format fasta -stop 1)
			touch "./$dir/$accession.fasta"
			echo "$Seq" > "./$dir/$accession.fasta"
			continue
		fi
	else
		# download the accession
		echo "sequence $accession not present, downloading"
		Seq=$(esearch -db nucleotide -query "$accession" | efetch -format fasta -stop 1)
		touch "./$dir/$accession.fasta"
		echo "$Seq" > "./$dir/$accession.fasta"
		# name is by accession.fasta
	fi
		# a) if >description and SeqData exist in the accession
				#continue
			# b) if the seq is invalid
				# delete the accession file and mark it to be downloaded
				# record deleted files in the warnings.log
			# c if OVERWRITE == true then treat  all sequences as missing accessions (put c first)
done
# for loop to iterate over the file to be downloaded
# do
		# download the accession from genbank using equary and efetch and save as accession.fasta
		# if the accession is invalid,report to the warnings.log which files weren't downloadedxy

