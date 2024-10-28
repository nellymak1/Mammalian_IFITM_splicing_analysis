#!/bin/bash

#Option to input single accession or feed in a file
read -p 'Accession numbers given as a file (y/n):' is_file

#Option to see output or to save as excel file
read -p 'Save results as excel file (y/n):' is_excel

if [ $is_excel == 'y' ]; then
    if [ $is_file == "y" ]; then
        #Ask for file path
        read -p "Enter the file path:" file_path

        #Ask for output file name
        read -p 'Enter output file name:' output_file
        output_file_xlsx="${output_file}.xlsx"

        #Get product report
        echo "Product report:"
        datasets summary gene accession --inputfile "$file_path" --report product --as-json-lines > product_report
        dataformat excel gene-product --inputfile product_report --outputfile ${output_file_xlsx} \
        --fields tax-name,symbol,description,gene-id,transcript-count,protein-count,transcript-accession,transcript-length,transcript-protein-accession,transcript-protein-length
        rm product_report

    else
        #Ask for accession number by user input
        read -p 'Enter accession number:' accession_number

        #Ask for output file name
        read -p 'Enter output file name:' output_file
        output_file_xlsx="${output_file}.xlsx"

        #Get product report
        echo "Product report:"
        datasets summary gene accession "$accession_number" --report product --as-json-lines > product_report
        dataformat excel gene-product --inputfile product_report --outputfile ${output_file_xlsx}\
        --fields tax-name,symbol,description,gene-id,transcript-count,protein-count,transcript-accession,transcript-length,transcript-protein-accession,transcript-protein-length
        rm product_report
    fi
else
    if [ $is_file == "y" ]; then
        #Ask for file path
        read -p "Enter the file path:" file_path
        #Get product report
        echo "Product report:"
        datasets summary gene accession --inputfile "$file_path" --report product --as-json-lines > product_report
        dataformat tsv gene-product --inputfile product_report \
        --fields tax-name,symbol,description,gene-id,transcript-count,protein-count,transcript-accession,transcript-length,transcript-protein-accession,transcript-protein-length
        rm product_report
    else
        #Ask for accession number by user input
        read -p 'Enter accession number:' accession_number

        #Get product report
        echo "Product report:"
        datasets summary gene accession "$accession_number" --report product --as-json-lines > product_report
        dataformat tsv gene-product --inputfile product_report \
        --fields tax-name,symbol,description,gene-id,transcript-count,protein-count,transcript-accession,transcript-length,transcript-protein-accession,transcript-protein-length
        rm product_report
    fi
fi