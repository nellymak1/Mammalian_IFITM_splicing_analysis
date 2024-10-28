library(readxl)
library(dplyr)
library(openxlsx)

blast_mammals <- read_excel("./blast_hIFITM3_against_mammals_tblastn_REPORT.xlsx", sheet = "Gene Product Report")

#Add column containing protein count as factor
blast_mammals$ProteinCountFactor <- factor(blast_mammals$`Protein Count`)

#Remove rows of non-protein coding genes
blast_mammals_filtered <- subset(blast_mammals, !is.na(blast_mammals$`Transcript Protein Accession`))

#Remove rows that encode known genes that are not IFITMs
blast_mammals_filtered <- filter(blast_mammals_filtered, grepl("LOC|IFITM", Symbol, ignore.case = TRUE))

#Create variable of all species names
species_list <- unique(blast_mammals_filtered$`Taxonomic Name`)

#Create empty dataframe to store results
transcript_count <- data.frame()

#For loop to count number of genes encoding different number of transcripts per species
for (species in species_list) {
  all <- subset(blast_mammals_filtered,`Taxonomic Name`== species)
  analysis_row <- data.frame(
    Species = species,
    Transcript_1 = nrow(subset(all,ProteinCountFactor==1)),
    Transcript_2 = nrow(subset(all,ProteinCountFactor==2))/2,
    Transcript_3 = nrow(subset(all,ProteinCountFactor==3))/3,
    Transcript_4 = nrow(subset(all,ProteinCountFactor==4))/4,
    Transcript_5 = nrow(subset(all,ProteinCountFactor==5))/5,
    Transcript_6 = nrow(subset(all,ProteinCountFactor==6))/6,
    Transcript_7 = nrow(subset(all,ProteinCountFactor==7))/7
  )
  transcript_count <- rbind(transcript_count, analysis_row)
  rm(analysis_row)
}

#Add column indicating whether there are alternatively spliced genes
transcript_count$spliced_genes <- rowSums(transcript_count[,3:8])
transcript_count$splicing <- as.factor(ifelse(transcript_count$spliced_genes != 0, "Yes", "No"))

#Save dataframe as excel
write.xlsx(transcript_count, "IFITM_gene_count_by_species.xlsx")

#Number of species with alternatively spliced IFITM genes
print(paste("Total number of species analysed:", nrow(transcript_count)))
print(paste("Total number of species with alternatively spliced IFITMs:", 
            nrow(subset(transcript_count,splicing == "Yes"))))
print(paste0("Percentage of species with alternatively spliced IFITMs: ", 
            round((nrow(subset(transcript_count,splicing == "Yes"))
             /nrow(transcript_count))*100, digits = 1), "%"))