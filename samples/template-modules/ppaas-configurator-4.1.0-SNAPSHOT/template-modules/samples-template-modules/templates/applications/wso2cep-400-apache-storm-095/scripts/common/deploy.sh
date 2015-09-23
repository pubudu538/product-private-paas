#!/bin/bash
# --------------------------------------------------------------
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
# --------------------------------------------------------------
#
iaas=$1
host_ip="{{MACHINE_IP}}"
host_port=9443

prgdir=`dirname "$0"`
script_path=`cd "$prgdir"; pwd`
zookeeper_type="zookeeper"
zookeeper_version="346"
zookeeper="${zookeeper_type}-${zookeeper_version}"
storm_type="storm"
storm_version="095"
storm="apache-${storm_type}-${storm_version}"
cep_type="wso2cep"
cep_version="400"
cep="${cep_type}-${cep_version}"
application_name="wso2cep-storm"
full_application_name="${cep_type}-${cep_version}-apache-${storm_type}-${storm_version}"
artifacts_path=`cd "${script_path}/../../artifacts"; pwd`
zk_cartridges_path=`cd "${script_path}/../../../../cartridges/${iaas}/${zookeeper}"; pwd`
storm_cartridges_path=`cd "${script_path}/../../../../cartridges/${iaas}/${storm}"; pwd`
cep_cartridges_path=`cd "${script_path}/../../../../cartridges/${iaas}/${cep}"; pwd`
cartridges_groups_path=`cd "${script_path}/../../../../cartridge-groups/${full_application_name}"; pwd`
autoscaling_policies_path=`cd "${script_path}/../../../../autoscaling-policies"; pwd`
network_partitions_path=`cd "${script_path}/../../../../network-partitions/${iaas}"; pwd`
deployment_policies_path=`cd "${script_path}/../../../../deployment-policies"; pwd`
application_policies_path=`cd "${script_path}/../../../../application-policies"; pwd`

network_partition_id="network-partition-1"
deployment_policy_id="deployment-policy-1"
autoscaling_policy_id="autoscaling-policy-1"
application_policy_id="application-policy-1"

set -e

if [[ -z "${iaas}" ]]; then
    echo "Usage: deploy.sh [iaas]"
    exit
fi

echo ${autoscaling_policies_path}/${autoscaling_policy_id}.json
echo "Adding autoscale policy..."
curl -X POST -H "Content-Type: application/json" -d "@${autoscaling_policies_path}/${autoscaling_policy_id}.json" -k -v -u admin:admin https://${host_ip}:${host_port}/api/autoscalingPolicies

echo "Adding network partitions..."
curl -X POST -H "Content-Type: application/json" -d "@${network_partitions_path}/${network_partition_id}.json" -k -v -u admin:admin https://${host_ip}:${host_port}/api/networkPartitions

echo "Adding deployment policy..."
curl -X POST -H "Content-Type: application/json" -d "@${deployment_policies_path}/${deployment_policy_id}.json" -k -v -u admin:admin https://${host_ip}:${host_port}/api/deploymentPolicies

echo "Adding Zookeeper cartridge..."
curl -X POST -H "Content-Type: application/json" -d "@${zk_cartridges_path}/${zookeeper_type}.json" -k -v -u admin:admin https://${host_ip}:${host_port}/api/cartridges

echo "Adding ${storm_type} - ${storm_version} Nimbus cartridge..."
curl -X POST -H "Content-Type: application/json" -d "@${storm_cartridges_path}/${storm_type}-nimbus.json" -k -v -u admin:admin https://${host_ip}:${host_port}/api/cartridges

echo "Adding ${storm_type} - ${storm_version} UI cartridge..."
curl -X POST -H "Content-Type: application/json" -d "@${storm_cartridges_path}/${storm_type}-ui.json" -k -v -u admin:admin https://${host_ip}:${host_port}/api/cartridges

echo "Adding ${storm_type} - ${storm_version} Supervisor cartridge..."
curl -X POST -H "Content-Type: application/json" -d "@${storm_cartridges_path}/${storm_type}-supervisor.json" -k -v -u admin:admin https://${host_ip}:${host_port}/api/cartridges

echo "Adding ${cep_type} - ${cep_version} Manager cartridge..."
curl -X POST -H "Content-Type: application/json" -d "@${cep_cartridges_path}/${cep_type}-manager.json" -k -v -u admin:admin https://${host_ip}:${host_port}/api/cartridges

echo "Adding ${cep_type} - ${cep_version} Worker cartridge..."
curl -X POST -H "Content-Type: application/json" -d "@${cep_cartridges_path}/${cep_type}-worker.json" -k -v -u admin:admin https://${host_ip}:${host_port}/api/cartridges

echo "Adding ${cep_type} - ${storm_type} cartridge Group ..."
curl -X POST -H "Content-Type: application/json" -d "@${cartridges_groups_path}/${application_name}-group.json" -k -v -u admin:admin https://${host_ip}:${host_port}/api/cartridgeGroups

sleep 1
echo "Adding application policy..."
curl -X POST -H "Content-Type: application/json" -d "@${application_policies_path}/${application_policy_id}.json" -k -v -u admin:admin https://${host_ip}:${host_port}/api/applicationPolicies

sleep 1
echo "Adding ${storm_type} - ${storm_version} application..."
curl -X POST -H "Content-Type: application/json" -d "@${artifacts_path}/${application_name}-application.json" -k -v -u admin:admin https://${host_ip}:${host_port}/api/applications

sleep 1
echo "Deploying application..."
curl -X POST -H "Content-Type: application/json" -k -v -u admin:admin https://${host_ip}:${host_port}/api/applications/${application_name}-application/deploy/${application_policy_id}
