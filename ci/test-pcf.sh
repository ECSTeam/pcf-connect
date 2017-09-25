#!/bin/bash -e

cmd=./pcf-repo/pcf

# test bosh not installed
echo "testing without bosh"
result=`echo $($cmd help)`
if [[ ! $result == Error* ]]; then
  echo "'Bosh not installed' test failed"
fi

# get "pcf" script required command line utilities - at some point just make a new docker image

# BOSH
echo "installing bosh v1"
gem install bosh_cli --silent --no-ri --no-rdoc

# test cf not installed
echo "testing without cf"
result=`echo $($cmd help)`
if [[ ! $result == Error* ]]; then
  echo "'cf not installed' test failed"
fi

# CF
echo "installing cf"
gem install curl --silent
curl -s -L "https://cli.run.pivotal.io/stable?release=linux64-binary" | tar -zx -C /usr/local/bin

# test jq not installed
echo "testing without jq"
result=`echo $($cmd help)`
if [[ ! $result == Error* ]]; then
  echo "'jq not installed' test failed"
fi

# jq
echo "installing jq"
curl -s -L 'https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64' -o /usr/local/bin/jq && chmod +x /usr/local/bin/jq

# UAAC
echo "installing uaac"
gem install cf-uaac --silent

# Do something useful
echo "test with bad credentials"
result=`echo $($cmd alias bad-creds -n $OPSMAN_HOST -u wronguser -p wrongpassword)`
if [[ ! $result == Error* ]]; then
  echo "Bad credentials did not fail properly"
fi

echo "running tests using bosh v1"
$cmd alias test-name -n $OPSMAN_HOST -u $OPSMAN_USERNAME -p $OPSMAN_PASSWORD -o $CF_ORG -s $CF_SPACE
$cmd target test-name
$cmd targets

# clean up bosh v1

rm -rf $HOME/.pcf
yes | gem uninstall bosh_cli --silent

# install bosh v2
echo "installing bosh v2"
curl -s -L 'https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-2.0.28-linux-amd64' -o /usr/local/bin/bosh && chmod +x /usr/local/bin/bosh

echo "running tests using bosh v2"
$cmd alias test-name -n $OPSMAN_HOST -u $OPSMAN_USERNAME -p $OPSMAN_PASSWORD -o $CF_ORG -s $CF_SPACE
$cmd target test-name
$cmd targets
