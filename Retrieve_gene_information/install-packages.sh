## Install NCBi datasets and dataformat
# version 14.3.0 was used for the script
# using conda (creating an environment)
conda create -n ncbi_datasets
conda activate ncbi_datasets
conda install -c conda-forge ncbi-datasets-cli
# for other installation methods see https://www.ncbi.nlm.nih.gov/datasets/docs/v2/download-and-install/