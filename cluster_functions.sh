function cluster.create() {
  aws emr create-cluster --applications Name=Spark --tags 'Name=greg-cluster' --ec2-attributes '{"KeyName":"greg-key29","InstanceProfile":"EMR_EC2_DefaultRole","SubnetId":"subnet-053f834c","EmrManagedSlaveSecurityGroup":"sg-0d2e1e07e0af53a99","EmrManagedMasterSecurityGroup":"sg-0d2e1e07e0af53a99"}' --release-label emr-5.10.0 --log-uri 's3n://aws-logs-295978219687-us-east-1/elasticmapreduce/' --instance-groups '[{"InstanceCount":'${1}',"EbsConfiguration":{"EbsBlockDeviceConfigs":[{"VolumeSpecification":{"SizeInGB":32,"VolumeType":"gp2"},"VolumesPerInstance":1}]},"InstanceGroupType":"CORE","InstanceType":"'"$2"'","Name":"Core - 2"},{"InstanceCount":1,"EbsConfiguration":{"EbsBlockDeviceConfigs":[{"VolumeSpecification":{"SizeInGB":32,"VolumeType":"gp2"},"VolumesPerInstance":1}]},"InstanceGroupType":"MASTER","InstanceType":"m4.large","Name":"Master - 1"}]' --configurations '[{"Classification":"emrfs-site","Properties":{"fs.s3.consistent.retryPeriodSeconds":"10","fs.s3.consistent":"true","fs.s3.consistent.retryCount":"5","fs.s3.consistent.metadata.tableName":"EmrFSMetadata"},"Configurations":[]}]' --auto-scaling-role EMR_AutoScaling_DefaultRole --bootstrap-actions '[{"Path":"s3://elasticmapreduce/bootstrap-actions/run-if","Args":["instance.isMaster=true","curl https://raw.githubusercontent.com/gversmee/bidou/master/cluster-ami-root.sh | sudo bash -s"],"Name":"Run if"}]' --ebs-root-volume-size 50 --service-role EMR_DefaultRole --enable-debugging --name `whoami`'-cluster' --scale-down-behavior TERMINATE_AT_TASK_COMPLETION --region us-east-1 --output=text
}

export -f cluster.create

function cluster.status() {
  aws emr describe-cluster --cluster-id ${1} --region us-east-1 --query Cluster.Status.State

}

export -f cluster.status

function cluster.terminate() {
  aws emr terminate-clusters --region us-east-1 --cluster-ids ${1}
}

export -f cluster.terminate

function cluster.dns() {
  export URL=`aws emr describe-cluster --cluster-id ${1} --region us-east-1 --query Cluster.MasterPublicDnsName`
	echo https://${URL}:8888
}

export -f cluster.dns
