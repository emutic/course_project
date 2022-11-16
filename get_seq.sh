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

# for loop iterate over each line (accession number) in the accessions file
# do
# this will mark files to be downloaded
#		if seq in dir
			# a) if >description and SeqData exist in the accession
				#continue
			# b) if the seq is invalid
				# delete the accession file and mark it to be downloaded
				# record deleted files in the warnings.log
			# c if OVERWRITE == true then treat  all sequences as missing accessions (put c first)
# for loop to iterate over the file to be downloaded
# do
		# download the accession from genbank using equary and efetch and save as accession.fasta
		# if the accession is invalid,report to the warnings.log which files weren't downloadedxy

