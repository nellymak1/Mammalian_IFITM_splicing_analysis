library(ggtree)
library(readxl)
library(dplyr)
library(ggplot2)
library(svglite)

# set working directory
setwd("~/OneDrive - University of Edinburgh/EDINBURGH PHD/IFITM PROJECT/Bioinformatics/Splicing Analysis/IFITMs_in_mammals_tblastn")

transcript_count <- read_excel("IFITM_gene_count_by_species.xlsx")

# Make a list of species names from blast results to make timetree
# species <- head(transcript_count$Species, n=205)
# writeLines(species,con = "species_name.txt")

# Make time tree on timetree.org but some species are unresolved
# substitutions cannot be found for Eptesicus fuscus, Bos indicus x Bos taurus,
# Rattus rattus, Neophocaena asiaeorientalis asiaorientalis
# Removed Canis lupus familiaris from list since it masks Canis lupus dingo

#Load tree
tree <- read.tree("timetree_mammals.nwk")

# Remove _ in tip label names
tree$tip.label <- gsub("_", " ", tree$tip.label) #remove _ in tip label name
tree$tip.label <- gsub("Canis lupus dingo", "Canis lupus familiaris", tree$tip.label)

# rearrange transcript_count dataframe to match order of tree tip labels
# might not be necessary to rearrange
# need to make a dataframe with column 1 being tip label 
# and other columns being other variables
d1 <- data.frame(node=tree$tip.label)
order_d1 <- match(d1$node, transcript_count$Species)
transcript_count_reordered <- transcript_count[order_d1, ]

splicing <- as.factor(transcript_count_reordered$splicing)
total_genes <- as.numeric(rowSums(transcript_count_reordered[,2:8]))

splicing_outcome <- transcript_count_reordered$`Non-synonymous`
splicing_outcome <- gsub("No", "Synonymous", splicing_outcome)
splicing_outcome <- gsub("Yes", "Non-synonymous", splicing_outcome)

Nterm_variation <- transcript_count_reordered$`YEML-difference`
Nterm_variation <- gsub("Yes", "*", Nterm_variation)
Nterm_variation <- gsub("No", NA, Nterm_variation)

d1 <- data.frame(node=tree$tip.label, 
                 splicing=splicing, 
                 total_genes=total_genes, 
                 splicing_outcome=splicing_outcome,
                 Nterm_variation=Nterm_variation)

# plot tree
library(phylobase)
tree_data <- phylo4d(tree, d1) #integrate tree and dataframe
p <- ggtree(tree_data, layout="circular", size=0.2) 
q <- ggtree(tree_data, size=0.2) 

# upright tree

# plot total_genes by colour as continuous scale
# p + geom_tippoint(size=0.5, aes(color=splicing))
# q + geom_tippoint(size=0.5, aes(color=total_genes)) + 
#  scale_color_gradientn(colors=rev(rainbow(5)), breaks=seq(0,30,by=5))
# q + geom_tippoint(size=0.5, aes(color=total_genes)) + 
#  scale_color_gradient(low="blue", high="red", breaks=seq(0,30,by=5))

q_points <- q + geom_tippoint(size=0.5, aes(color=total_genes)) + 
  scale_color_gradientn(colors=terrain.colors(5), breaks=seq(0,30,by=5)) + 
  labs(color = "Number of \nIFITM genes") +
  theme(legend.position = c(0.2,0.7), legend.title = element_text(size=8, face ="bold"),
        legend.text = element_text(size=8))
q_points
  
# Can also plot total_genes by colour as discrete variable
# hcl.pals()
# hcl.colors(5, palette="Fall")
# q + geom_tippoint(size=0.5, aes(color=total_genes)) + 
#  scale_color_stepsn(colors=hcl.colors(6, palette="Fall"), breaks=seq(0,30,by=5))

# colour tip labels by whether there are splicing
q_labels <- q + xlim(0,230) +
  geom_tiplab(aes(color=splicing_outcome), size=0.8, 
              align = TRUE, offset = 0.5, linesize = 0) +
  scale_color_manual(values = c("darkred", "darkblue"), na.value = "black",
                     labels = c("Non-synonymous", "Synonymous","No splicing")) +
  labs(color = "Splicing outcome") +
  theme(legend.title = element_text(size = 8, face = "bold"), 
        legend.title.align = 0.5,
        legend.text = element_text(size = 8)) +
  guides(color = guide_legend(override.aes = list(label="\u25A0",size=3)))
q_labels

q_points + q_labels

#ggsave("tree_tiplabels.svg", plot = q_labels, device = "svg")
#ggsave("tree_tippoints.svg", plot = q_points, device = "svg")


# circular tree

p <- ggtree(tree_data, layout="circular", size=0.2)  

#p_points <- p + geom_tippoint(size=0.8, aes(color=total_genes)) + 
  scale_color_gradientn(colors=terrain.colors(8), breaks=c(1,3,5,10,20), trans="log10") + 
  labs(color = "Number of \nIFITM genes") +
  theme(legend.title = element_text(size=8, face ="bold"),
        legend.text = element_text(size=8))


p_points <- p + geom_tippoint(size=0.5, aes(color=total_genes)) + 
  labs(color = "Number of IFITM genes") +
  theme(legend.title = element_text(size=8, face ="bold"),
        legend.text = element_text(size=8),
        legend.direction = 'horizontal') +
  guides(color = guide_colourbar(title.position="top", title.hjust = 0.5)) +
  scale_color_stepsn(colors=c("ivory1","rosybrown1","indianred1","indianred4"),
                     breaks=c(1,2,5,10,20), trans="log10")
p_points

p_labels <- p + xlim(0,230) +
  geom_tiplab(aes(color=splicing_outcome), size=1.5, 
              align = TRUE, offset = 2, linesize = 0) +
  scale_color_manual(values = c("indianred3", "royalblue"), na.value = "black",
                     labels = c("Non-synonymous", "Synonymous","None")) +
  labs(color = "IFITM splice variants") +
  theme(legend.title = element_text(size = 8, face = "bold"), 
        legend.title.align = 0.5,
        legend.text = element_text(size = 8)) +
  guides(color = guide_legend(override.aes = list(label="\u25A0",size=5)))
p_labels

p_labels + geom_text(aes(label=Nterm_variation), color="black")


#ggsave("circular_tippoints.svg", plot = p_points, device = "svg")
#ggsave("circular_tiplabels.svg", plot = p_labels, device = "svg")


####################################################################


# subsetting trees
library(treeio)

q_labels + geom_text(aes(label=node), size=1, hjust=.2, color="red")
#ggsave("tree_nodes.svg", device = "svg") 
# chiroptera common ancestor = node 295

tree_bats <- tree_subset(tree, node = 295, levels_back = 0)
#ggtree(tree_bats)

# rearrange transcript_count dataframe to match order of tree tip labels
# might not be necessary to rearrange
# need to make a dataframe with column 1 being tip label 
# and other columns being other variables

order_d2 <- match(tree_bats$tip.label, transcript_count$Species)
transcript_count_reordered <- transcript_count[order_d2, ]

total_genes <- as.numeric(rowSums(transcript_count_reordered[,2:8]))

splicing_outcome <- transcript_count_reordered$`Non-synonymous`
splicing_outcome <- gsub("No", "Synonymous", splicing_outcome)
splicing_outcome <- gsub("Yes", "Non-synonymous", splicing_outcome)

Nterm_variation <- transcript_count_reordered$`YEML-difference`
Nterm_variation <- gsub("Yes", "*", Nterm_variation)
Nterm_variation <- gsub("No", NA, Nterm_variation)

d2 <- data.frame(node=tree_bats$tip.label,
                 total_genes=total_genes, 
                 splicing_outcome=splicing_outcome,
                 Nterm_variation=Nterm_variation)

#integrate tree and dataframe
tree_data_bats <- phylo4d(tree_bats, d2) 

q_bats <- ggtree(tree_data_bats)
q_bats_points <- q_bats + xlim(0,100) +
  geom_tippoint(size=3, aes(color=total_genes)) +
  labs(color = "Number of IFITM genes") +
  theme(legend.title = element_text(size=8, face ="bold"),
        legend.text = element_text(size=8),
        legend.direction = "horizontal")  +
        guides(colour = guide_colourbar(title.position="top", title.hjust = 0.5)) +
  scale_color_gradientn(colors=terrain.colors(20), breaks=c(1,5,10,15))
q_bats_points

# discrete scale bar for tip colours
q_bats + 
  xlim(0,200) +
  geom_tippoint(size=3, aes(fill=total_genes), pch=21, color="black") +
  labs(fill = "Number of IFITM genes") +
  theme(legend.title = element_text(size=8, face ="bold"),
        legend.text = element_text(size=8),
        legend.direction = "horizontal")  + 
  guides(fill = guide_colourbar(title.position="top", title.hjust = 0.5)) +
 scale_fill_stepsn(#colors=c("black","#A27CA1","#FFD6FE","white"),
                    colors=c("ivory1","rosybrown1","indianred1","indianred4"),
                    breaks=c(1,2,5,10), trans="log10")
 
ggsave("tree_bats_tippoints_discrete.svg", device = "svg")

q_bats + theme_tree2()

q_bats_labels <- q_bats + xlim(0,100) +
  geom_tiplab(aes(color=splicing_outcome), size=3, 
              align = TRUE, offset = 2, linesize = 0) +
  scale_color_manual(values = c("indianred3", "royalblue4"), na.value = "black",
                     labels = c("Non-synonymous", "Synonymous","None")) +
  labs(color = "IFITM splice variants") +
  theme(legend.title = element_text(size = 8, face = "bold"), 
        legend.title.align = 0.5,
        legend.text = element_text(size = 8)) +
  guides(color = guide_legend(override.aes = list(label="\u25A0",size=5)))
q_bats_labels

#ggsave("tree_bats_tiplabels.svg", plot = q_bats_labels, device = "svg")
#ggsave("tree_bats_tippoints.svg", plot = q_bats_points, device = "svg")

