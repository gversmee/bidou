#!/bin/bash

# generate jupyter config file

su bidou
cd /home/bidou
jupyter notebook --generate-config
wget https://raw.githubusercontent.com/gversmee/bidou/master/jupyter_notebook_config.py -O /home/bidou/.jupyter/jupyter_notebook_config.py

# generate ssl certificate
openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout /home/bidou/.jupyter/sslcert.pem -out /home/bidou/.jupyter/sslcert.pem -subj "/C=US/ST=MA/L=Boston/O=HMS/CN=."

nohup jupyter lab & > /home/bidou/.jupyter/jupyterlog.txt 2>&1
