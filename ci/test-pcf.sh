#!/bin/bash -e

# get "pcf" script required command line utilities - at some point just make a new docker image

# BOSH
echo "installing bosh"
gem install bosh_cli --no-ri --no-rdoc

# gem install apk

# CF
echo "installing cf"
gem install curl
curl -L "https://cli.run.pivotal.io/stable?release=linux64-binary" | tar -zx -C /usr/local/bin

# wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | apt-key add -
# echo "deb http://packages.cloudfoundry.org/debian stable main" | tee /etc/apt/sources.list.d/cloudfoundry-cli.list
# apt-get -y update
# apt-get -y install cf-cli

# UAAC
echo "installing uaac"
gem install cf-uaac

# jq
echo "installing jq"
curl -L 'https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64' -o /usr/local/bin/jq && chmod +x /usr/local/bin/jq
# apt-get install jq

# Do something useful

echo "running tests"
cmd=./pcf-repo/pcf

$cmd alias test-name -n $OPSMAN_HOST -u $OPSMAN_USERNAME -p $OPSMAN_PASSWORD -o $CF_ORG -s $CF_SPACE
$cmd target test-name
$cmd targets
