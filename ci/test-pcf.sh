#!/bin/bash -e

# get "pcf" script required command line utilities - at some point just make a new docker image

# BOSH
echo "installing bosh"
gem install bosh_cli --silent --no-ri --no-rdoc

# CF
echo "installing cf"
gem install curl --silent
curl -s -L "https://cli.run.pivotal.io/stable?release=linux64-binary" | tar -zx -C /usr/local/bin

# UAAC
echo "installing uaac"
gem install cf-uaac --silent

# jq
echo "installing jq"
curl -s -L 'https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64' -o /usr/local/bin/jq && chmod +x /usr/local/bin/jq

# Do something useful

echo "running tests"
cmd=./pcf-repo/pcf

$cmd alias test-name -n $OPSMAN_HOST -u $OPSMAN_USERNAME -p $OPSMAN_PASSWORD -o $CF_ORG -s $CF_SPACE
$cmd target test-name
$cmd targets
