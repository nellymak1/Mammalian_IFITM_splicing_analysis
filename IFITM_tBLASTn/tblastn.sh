#!/bin/bash

#set database variable
databases=$(cat ./databases/refseq_rna_list.txt)

#set query
#read -p "Enter the path to the query protein fasta file:" query

#set taxid
read -p "Taxid of the species you want to search against:" taxid

#make output file
read -p "Output file name:" output_file

#make sure output file does not already exist
if [ -f "$output_file" ]; then
	echo "------------OOPSIE!--------------"
	echo "File already exists. Please choose a different name."
	read -p "New output file name:" output_file
fi

#blastn search against all databases
for db in $databases; do
	echo "Running blast against database: $db"
	tblastn -query $query -db $db -evalue 1e-20 -outfmt "6 saccver stitle" -taxids "$taxid" >> "$output_file"
done

echo "************************************************************************"
echo "Here are the results..."
cat "$output_file"