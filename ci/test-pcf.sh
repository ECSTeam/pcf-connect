#!/bin/bash -ex

# get "pcf" script required command line utilities

# echo "installing sudo"
# apt-get install sudo

echo "install ruby"
apt-get install ruby-full

# BOSH
echo "installing bosh"
gem install bosh_cli --no-ri --no-rdoc

# CF
echo "installing cf"
wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | sudo apt-key add -
echo "deb http://packages.cloudfoundry.org/debian stable main" | sudo tee /etc/apt/sources.list.d/cloudfoundry-cli.list
apt-get update
apt-get install cf-cli

# UAAC
echo "installing uaac"
gem install cf-uaac

# jq
# echo "installing jq"
# sudo apt-get install jq

# Do something useful

echo "running tests"
cmd=./pcf-repo/pcf

$cmd alias test-name -n $OPSMAN_HOST -u $OPSMAN_USERNAME -p $OPSMAN_PASSWORD -o $CF_ORG -s $CF_SPACE

$cmd target test-name
$cmd targets
