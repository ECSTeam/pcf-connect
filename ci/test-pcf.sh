#!/bin/bash -e

cmd=./pcf-repo/pcf

# test bosh not installed
echo -n "Running test: bosh missing "
result=`echo $($cmd help)`
if [[ ! $result == Error* ]]; then
  echo "(FAILED)"
fi
echo "(PASSED)"

# get "pcf" script required command line utilities

# BOSH
echo -n "Installing bosh v1..."
gem install bosh_cli --silent --no-ri --no-rdoc
echo "done!"

# test cf not installed
echo -n "Running test: cf missing "
result=`echo $($cmd help)`
if [[ ! $result == Error* ]]; then
  echo "(FAILED)"
fi
echo "(PASSED)"

# CF
echo -n "Installing cf..."
gem install curl --silent
curl -s -L "https://cli.run.pivotal.io/stable?release=linux64-binary" | tar -zx -C /usr/local/bin
echo "done!"

# test jq not installed
echo -n "Running test: jq missing "
result=`echo $($cmd help)`
if [[ ! $result == Error* ]]; then
  echo "(FAILED)"
fi
echo "(PASSED)"

# jq
echo -n "Installing jq..."
curl -s -L 'https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64' -o /usr/local/bin/jq && chmod +x /usr/local/bin/jq
echo "done!"

# UAAC
echo -n "Installing uaac..."
gem install cf-uaac --silent
echo "done!"

# Do something useful
echo -n "Running test: bad credentials "
result=`echo $($cmd alias bad-creds -n $OPSMAN_HOST -u wronguser -p wrongpassword)`
if [[ ! $result == Error* ]]; then
  echo "(FAILED)"
fi
echo "(PASSED)"

echo "Running test: using bosh v1"
$cmd alias test-name -n $OPSMAN_HOST -u $OPSMAN_USERNAME -p $OPSMAN_PASSWORD -o $CF_ORG -s $CF_SPACE
$cmd target test-name
$cmd targets

# clean up bosh v1
rm -rf $HOME/.pcf
yes | gem uninstall bosh_cli --silent

# install bosh v2
echo -n "Installing bosh v2..."
curl -s -L 'https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-2.0.28-linux-amd64' -o /usr/local/bin/bosh && chmod +x /usr/local/bin/bosh
echo "done!"

echo "Running test: using bosh v2"
$cmd alias test-name -n $OPSMAN_HOST -u $OPSMAN_USERNAME -p $OPSMAN_PASSWORD -o $CF_ORG -s $CF_SPACE
$cmd target test-name
$cmd targets

# test with differently named 'bosh' command
echo "Running test: custom 'bosh' command name"
mv /usr/local/bin/bosh /usr/local/bin/bosh2
export BOSH_CMD=bosh2
$cmd targets

echo "SUCCESS!"
