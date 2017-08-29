#!/bin/bash -ex

# get "pcf" script required command line utilities

echo "looking good!"

which gem

# BOSH
# gem install bosh_cli --no-ri --no-rdoc
#
# # CF
# wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | sudo apt-key add -
# echo "deb http://packages.cloudfoundry.org/debian stable main" | sudo tee /etc/apt/sources.list.d/cloudfoundry-cli.list
# sudo apt-get update
# sudo apt-get install cf-cli
#
# # ...first configure the Cloud Foundry Foundation package repository
# # sudo wget -O /etc/yum.repos.d/cloudfoundry-cli.repo https://packages.cloudfoundry.org/fedora/cloudfoundry-cli.repo
# # sudo yum install cf-cli
#
# # UAAC
# gem install cf-uaac
#
# # jq
# sudo apt-get install jq
#
# # Do something useful
#
# cmd=./pcf-repo/pcf
#
# $cmd alias test-name -n $OPSMAN_HOST -u $OPSMAN_USERNAME -p $OPSMAN_PASSWORD -o $CF_ORG -s $CF_SPACE
#
# $cmd target test-name
# $cmd targets
