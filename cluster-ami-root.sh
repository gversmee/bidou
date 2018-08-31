#!/bin/bash

yum upgrade -y
yum install wget net-tools lsof bash-completion vim docker bzip2 firewalld xauth deltarpm bzip2-devel zlib-devel xz-devel -y
yum clean all -y

# install conda
wget https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh
chmod +x Anaconda3-5.2.0-Linux-x86_64.sh
./Anaconda3-5.2.0-Linux-x86_64.sh -b -p /opt/anaconda3
rm -f Anaconda3-5.2.0-Linux-x86_64.sh

## put the bin path for everybody
echo 'pathmunge /opt/anaconda3/bin' > /etc/profile.d/anaconda3.sh
chmod +x /etc/profile.d/anaconda3.sh
source /etc/profile

# install conda packages
conda config --append channels conda-forge --append channels r --append channels bioconda --append channels cyclus --append channels blaze --append channels pytorch
#conda install tensorflow pytorch -y
conda install htop sas_kernel git nano ipykernel wget tar unzip pyhamcrest java-jdk jupyterlab nodejs xorg-libxrender jupyterhub -y
conda install r r-devtools r-rlist r-lme4 r-reticulate r-irkernel r-essentials -y
conda install bcftools plink samtools htslib sra-tools -y
conda install -c conda-forge ncurses -y

#install latest ggplot2 and ggthemes
conda remove r-ggplot2 -y
R -e 'httr::set_config(httr::config(ssl_verifypeer = 0L, ssl_verifyhost = 0L, ssl_verifystatus  = 0L)); install.packages("ggthemes", repos = "https://cran.cnr.berkeley.edu/")'

#install SAS and bash kernel
pip install msgpack
pip install --upgrade pip
pip install bash_kernel
python -m bash_kernel.install

#install python2
conda create -n python2 python=2 ipykernel -y
source activate python2
/opt/anaconda3/envs/python2/bin/python -m ipykernel install --prefix=/usr/local --name 'Python_2'
source deactivate

jupyter labextension install jupyterlab_bokeh

adduser -m -p uH3wonMUgnZBg bidou
usermod -aG wheel bidou

chgrp wheel -R /opt
chmod g+rw -R /opt
chgrp wheel -R /home/hadoop
chmod g+w -R /home/hadoop
chgrp wheel -R /etc/profile
chmod g+w -R /etc/profile