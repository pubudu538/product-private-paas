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

# run script sets the configurable parameters for the cartridge agent in agent.conf and
# starts the cartridge agent process.
#printenv >> /tmp/envs

local_ip=`awk 'NR==1 {print $1}' /etc/hosts`
server_path=/mnt
super_tenant_artifact_repo_path=repository/deployment/server/
mkdir -p $server_path
unzip /opt/wso2${WSO2_SERVER_TYPE}-${WSO2_SERVER_VERSION}.zip -d $server_path
rm /opt/wso2${WSO2_SERVER_TYPE}-${WSO2_SERVER_VERSION}.zip

export CARBON_HOME="$server_path/wso2${WSO2_SERVER_TYPE}-${WSO2_SERVER_VERSION}"
echo "CARBON_HOME=${CARBON_HOME}" >> /etc/environment
echo "CARBON_HOME is set to ${CARBON_HOME}"

# Workaround : since CEP is used as a ST application for hackathon
export APPLICATION_PATH="${CARBON_HOME}/$super_tenant_artifact_repo_path"
export "APPLICATION_PATH=${APPLICATION_PATH}" >> /etc/environment
echo "APPLICATION_PATH is set to ${APPLICATION_PATH}"


if [ "${START_CMD}" = "PCA" ]; then
    echo "Starting python cartridge agent..."
	/usr/local/bin/start-agent.sh
	echo "Python cartridge agent started successfully"
else
    echo "Configuring wso2 ${WSO2_SERVER_TYPE} ..."
    echo "Environment variables:"
    printenv
    pushd ${CONFIGURATOR_HOME}
    python configurator.py
    popd
    echo "WSO2 Carbon server configured successfully"
    echo ${CONFIG_PARAM_ZK_HOST} xanK >>/etc/hosts
    echo "Starting WSO2 Carbon server"
# $PROFILE value should be analytics or receiver
    if [ -n "$CONFIG_PARAM_PROFILE" ]; then
        if [ "$CONFIG_PARAM_PROFILE" = "analytics" ];then
            echo "Starting analytics profile"
            ${CARBON_HOME}/bin/wso2server.sh -DdisableEventSink=true
        elif [ "$CONFIG_PARAM_PROFILE" = "receiver" ];then
            echo "Starting receiver profile"
            ${CARBON_HOME}/bin/wso2server.sh -DdisableAnalyticsExecution=true -DdisableAnalyticsEngine=true
        elif [ "$CONFIG_PARAM_PROFILE" = "dashboard" ];then
            echo "Starting dashbord profile"
            ${CARBON_HOME}/bin/wso2server.sh -DdisableEventSink=true -DdisableAnalyticsExecution=true -DdisableAnalyticsEngine=true
        elif [ "$CONFIG_PARAM_PROFILE" = "default" ];then
            ${CARBON_HOME}/bin/wso2server.sh
        fi
    else
        echo "PROFILE is not set as environment variable"
    fi
    echo "WSO2 Carbon server started successfully"
fi
