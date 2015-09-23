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

export CARBON_HOME="/opt/zookeeper-3.4.6"
echo "CARBON_HOME=${CARBON_HOME}" >> /etc/environment
echo "CARBON_HOME is set to ${CARBON_HOME}"

# ZK data directory is hard-coded here
mkdir -p /tmp/zookeeper

if [ "${START_CMD}" = "PCA" ]; then
    echo "Starting python cartridge agent..."
	/usr/local/bin/start-agent.sh
	echo "Python cartridge agent started successfully"
else
    echo "Configuring ${SERVER_TYPE} ..."
    echo "Environment variables:"
    printenv
    pushd ${CONFIGURATOR_HOME}
    python configurator.py
    popd
    echo "${SERVER_TYPE} configured successfully"

    echo "Starting ${SERVER_TYPE}"
    ${CARBON_HOME}/bin/zkServer.sh start
    echo "${SERVER_TYPE} started successfully"
fi