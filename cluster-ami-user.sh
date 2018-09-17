#!/bin/bash

source /etc/profile

#install Hail
JAVA_HOME=''
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

#import hail tuto
mkdir /home/bidou/hail_tuto
mv /opt/hail/python/hail/docs/tutorials/* /home/bidou/hail_tuto

usermod -aG hadoop bidou
chown bidou -R /home/bidou

# generate jupyter config file
su bidou
source /etc/profile
cd /home/bidou
jupyter notebook --generate-config
wget https://raw.githubusercontent.com/gversmee/bidou/master/jupyter_notebook_config.py -O /home/bidou/.jupyter/jupyter_notebook_config.py

# generate ssl certificate
openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout /home/bidou/.jupyter/sslcert.pem -out /home/bidou/.jupyter/sslcert.pem -subj "/C=US/ST=MA/L=Boston/O=HMS/CN=."

nohup jupyter lab & > /home/bidou/.jupyter/jupyterlog.txt 2>&1
