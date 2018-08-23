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

#install Hail
git clone https://github.com/broadinstitute/hail.git /opt/hail
cd /opt/hail
./gradlew -Dspark.version=2.2.0 shadowJar archiveZip
ln -s /usr/lib/spark /opt/spark
PROFHAIL=/etc/profile.d/hail.sh
echo 'export SPARK_HOME=/opt/spark' > $PROFHAIL
echo 'export HAIL_HOME=/opt/hail' >> $PROFHAIL
echo 'export PYTHONPATH="${PYTHONPATH:+$PYTHONPATH:}$HAIL_HOME/build/distributions/hail-python.zip"' >> $PROFHAIL
echo 'export PYTHONPATH="$PYTHONPATH:$SPARK_HOME/python"' >> $PROFHAIL
echo 'export PYTHONPATH="$PYTHONPATH:$SPARK_HOME/python/lib/py4j-*-src.zip"' >> $PROFHAIL
echo 'JAR_PATH="$HAIL_HOME/build/libs/hail-all-spark.jar:/usr/share/aws/emr/emrfs/lib/emrfs-hadoop-assembly-2.20.0.jar"' >> $PROFHAIL
echo 'export PYSPARK_SUBMIT_ARGS="--jars $HAIL_HOME/build/libs/hail-all-spark.jar --conf spark.driver.extraClassPath=$JAR_PATH --conf spark.executor.extraClassPath=./hail-all-spark.jar --conf spark.serializer=org.apache.spark.serializer.KryoSerializer --conf spark.kryo.registrator=is.hail.kryo.HailKryoRegistrator pyspark-shell"' >> $PROFHAIL
source /etc/profile

conda env create -n hail -f $HAIL_HOME/python/hail/environment.yml
source activate hail
conda install pyhamcrest ipykernel cython py4j java-jdk -y
/opt/anaconda3/envs/hail/bin/python -m ipykernel install --prefix=/usr/local --name 'Hail'
source deactivate

adduser -m -p uH3wonMUgnZBg bidou
usermod -aG wheel bidou
usermod -aG hadoop bidou

chgrp wheel -R /opt
chmod g+rw -R /opt
chgrp wheel -R /home/hadoop
chmod g+w -R /home/hadoop
chgrp wheel -R /etc/profile
chmod g+w -R /etc/profile

curl https://raw.githubusercontent.com/gversmee/bidou/master/cluster-ami-user.sh | su -c "bash -s" bidou
