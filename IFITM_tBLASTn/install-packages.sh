## Download standalone BLAST setup for Unix https://www.ncbi.nlm.nih.gov/books/NBK52640/
# ACTION: Visit https://ftp.ncbi.nlm.nih.gov/blast/executables/LATEST/
# ACTION: Download desired archive to desired directory (folder)
tar -xvzf ncbi-blast-2.10.1+-x64-linux.tar.gz

## Download RNA Refseq genome databases
mkdir databases
cd databases
# ACTION: Visit https://ftp.ncbi.nlm.nih.gov/blast/db/
# ACTION: Download all "refseq_rna.*.tar.gz" and "refseq_rna.*.tar.gz.md5" files to the databases folder
dir > refseq_rna_list.txt # create database list
sed -i '/.md5/d' refseq_rna_list.txt
sed -i '/.txt/d' refseq_rna_list.txt
sed -i -e 's/.tar.gz//g' refseq_rna_list.txt
tar -xvzf refseq_rna.*.tar.gz # unzip files