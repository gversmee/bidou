#!/usr/bin/bash

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

## install the cluster functions
wget https://raw.githubusercontent.com/gversmee/bidou/master/cluster_functions.sh -P /etc/profile.d
chmod +x /etc/profile.d/cluster_functions.sh
source /etc/profile

# install conda packages
conda config --append channels conda-forge --append channels r --append channels bioconda --append channels cyclus --append channels blaze --append channels pytorch
conda install keras tensorflow pytorch r r-lme4 r-devtools r-reticulate htop bcftools samtools plink htslib sra-tools r-irkernel sas_kernel git nano curl ipykernel wget tar unzip pyhamcrest java-jdk jupyterlab nodejs r-essentials xorg-libxrender jupyterhub -y
conda install -c conda-forge ncurses -y

# install jupyter
# generate ssl certificate
openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout /srv/sslkey.pem -out /srv/sslcert.pem -subj "/C=US/ST=MA/L=Boston/O=HMS/CN=."

# generate jupyterhub config file
mkdir /etc/jupyterhub
openssl rand -hex 32 > /etc/jupyterhub/jupyterhub_cookie_secret
chmod 600 /etc/jupyterhub/jupyterhub_cookie_secret
cd /etc/jupyterhub
jupyterhub --generate-config
cd ~
wget https://raw.githubusercontent.com/gversmee/bidou/master/jupyterhub_config.py -O /etc/jupyterhub/jupyterhub_config.py

#install R , SAS and bash kernel
pip install --upgrade pip
pip install msgpack
pip install bash_kernel
python -m bash_kernel.install

#install python2
conda create -n python2 python=2 ipykernel -y
source activate python2
/opt/anaconda3/envs/python2/bin/python -m ipykernel install --prefix=/usr/local --name 'Python2'
source deactivate

#install jupterlab-hub extension
jupyter labextension install @jupyterlab/hub-extension

#install datadog agent
#DD_API_KEY=mydatadogapikey bash -c "$(curl -L https://raw.githubusercontent.com/DataDog/datadog-agent/master/cmd/agent/install_script.sh)"

#install rstudio server
wget https://download2.rstudio.org/rstudio-server-rhel-1.1.456-x86_64.rpm
yum install rstudio-server-rhel-1.1.456-x86_64.rpm
sh -c 'echo "rsession-which-r=/opt/anaconda3/bin/R" >> /etc/rstudio/rserver.conf'
rstudio-server start

# change permission for opt / etc and srv
chgrp wheel -R /opt
chmod g+rw -R /opt
chgrp wheel -R /etc/profile.d
chmod g+w -R /etc/profile.d
chgrp wheel -R /etc/jupyterhub
chmod g+rw -R /etc/jupyterhub
chgrp wheel -R /srv
chmod g+w -R /srv

adduser -m -p uH3wonMUgnZBg greg
usermod -aG wheel greg

adduser -m -p uH3wonMUgnZBg laura
usermod -aG wheel laura

adduser -m -p ByvlMYv6d7jWE paul
adduser -m -p sJH1A.htKTNAs nih

rstudio-server start
cd /etc/jupyterhub
nohup jupyterhub &