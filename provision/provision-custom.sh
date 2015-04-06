#!/bin/bash
#
# provision-custom.sh
#
# This file is specified in Vagrantfile and is loaded by Vagrant after the
# primary provision.sh file is run.

# Install latest Bedrock
echo -e "Attempting to install Bedrock via Composer. See http://github.com/roots/bedrock"
/srv/config/custom/bedrock-config/bedrock.sh