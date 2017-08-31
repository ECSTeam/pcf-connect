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

echo "running tests using bosh v1"
cmd=./pcf-repo/pcf

$cmd alias test-name -n $OPSMAN_HOST -u $OPSMAN_USERNAME -p $OPSMAN_PASSWORD -o $CF_ORG -s $CF_SPACE
$cmd target test-name
$cmd targets

# clean up

rm -rf $HOME/.pcf
gem uninstall bosh_cli -y

curl -s -L 'https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-2.0.28-linux-amd64' -o /usr/local/bin/bosh && chmod +x /usr/local/bin/bosh

echo "running tests using bosh v2"
cmd=./pcf-repo/pcf

$cmd alias test-name -n $OPSMAN_HOST -u $OPSMAN_USERNAME -p $OPSMAN_PASSWORD -o $CF_ORG -s $CF_SPACE
$cmd target test-name
$cmd targets
