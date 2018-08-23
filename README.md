
# Create a cluster to analyze genomic data with Hail
We have created an access to allow the creation of cluster on AWS with all packages necessary to conduct biomedical research. In this tutorial, we are explaining how to create, connect and terminate a cluster.
### Step 1: Connect and login to JupyterLabHub
###### https://ec2-18-232-139-163.compute-1.amazonaws.com:8000
This website contains a JupyterLabHub. In order to access it, you need to ask your credentials to the administrator.
### Step 2: Open a "Bash" Notebook
We have created functions to create, access and terminate your cluster.
For instance, running the following function will provide you a cluster with 2 "m4.large" machines as working nodes. Look here if you want to know the name and the specifications of AWS instances types: https://aws.amazon.com/ec2/instance-types/.


```bash
cluster.create 2 "m4.large"
```

### Step 3: Follow the status of your cluster creation
At this point in time, the cluster creation takes about 40 minutes. This is due to the fact that we are providing a lot of tools and packages to conduct biomedical research. In the near future, we plan to reduce significantly the login time. You  can follow the advancement of the process by running the following function, using the cluster ID that you previously got during the creation process. Once the status is "WAITING", you are ready to connect


```bash
cluster.status j-XXXXXXXXXXXXX
```

### Step 4: Connect to your new cluster
Run the following command to get the URL address of your cluster (remove the quotes if necessary). This will open a Jupyter Lab with already some tutorials that you can play with. For the moment, you will need a password to connect to your cluster, that will be provided by the administrator. We plan to simplify the authentication process soon.
Be careful, if you want to run Hail tutorials, make sure to select a "Hail" kernel.


```bash
cluster.dns j-XXXXXXXXXXXXX
```

### Step 5: Terminate your cluster
Once your job is done, please terminate your cluster to avoid unnecessary fees. For that, run the following command.


```bash
cluster.terminate j-XXXXXXXXXXXXX
```
