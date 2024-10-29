# Mammalian_IFITM_splicing_analysis :paw_prints:
This repository contains bash and R scripts for the IFITM splicing analysis in the following [preprint](https://www.biorxiv.org/content/10.1101/2023.12.04.569605v1.full):

:bat: Alternative splicing expands the antiviral IFITM repertoire in Chinese horseshoe bats
Nelly Mak, Dan Zhang, Xiaomeng Li, Kazi Rahman, Siddhartha A.K. Datta, Jordan Taylor, Jingyan Liu, Zhengli Shi, Nigel Temperton, Aaron T. Irving, Alex A. Compton, Richard D. Sloan
bioRxiv 2023.12.04.569605; doi: https://doi.org/10.1101/2023.12.04.569605

## Overview
The analysis is split into four parts: 
1. tBLASTn search
2. Gene transcript information retrieval
3. Alternative splicing analysis
4. Plotting

Parts 1-2 are written as a generic bash script and can be adapted to search for any gene(s) of interest in any set of species. It is designed to be interactive for the ease of use. Once the set-up is finished you are good to go - just follow the prompts on the screen as you run the script! The tBLASTn search is a local search thus requires databases (RefSeq RNA) to be downloaded.

Parts 3-4 are written in R (version 4.2.3) for the specific analysis of mammalian IFITM genes, with data acquired from the first two steps.

## Part 1: tBLASTn search :mag:
- Use the `IFITM_tBLASTn` folder
- Follow `install-packages.sh` to download dependencies and setup your local environment (bash)
- Run the interactive script `tblastn.sh`

## Part 2: Gene transcript information retrieval :dna:
- Use the `Retrieve_gene_information` folder
- Follow `install-packages.sh` to download dependencies and setup your local environment (bash)
- Run the interactive script `datasets_get_reports.sh`

## Part 3: Alternative splicing analysis :scissors:
- Use the `Splicing_analysis` folder
- Run `install-packages.R` to install required packages
- Run `IFITM_blast_report_analysis.R`

The script analyses the file `blast_hIFITM3_against_mammals_tblastn_REPORT.xlsx` that is the output of part 2. 
To analyse a different file simply change the file name in line 5 of the script and make sure the file in in the working directory.

## Part 4: Plotting :chart_with_upwards_trend:
- Use the `Splicing_tree_plotting` folder
- Run `install-packages.R` to install required packages
- Run `Tree_construction.R`
    - the script requires a .nwk file (phylogenetic tree) generated on NCBI Taxonomy which is only accessible via its web interface
    - the file `phyliptree_206mammals.phy` is the example tree generated and used in the script

The script analyses the file `IFITM_gene_count_by_species.xlsx` that is the output of part 3.
As above, to analyse a different file simply change the file name in line 8 of the script and make sure the file in in the working directory.