# Description

`pcf` is a command line utility used to easily switch between PCF environments.

This script developed and tested on Mac OS X.

# Prerequisites

This script assumes that the following command line utilities are already installed:

- `jq`
- `cf`
- `bosh` (version 1.x)
- `uaac`

# Installation

You don't need to `git clone` this entire repository. All that's needed is the `pcf` script itself.

Place the `pcf` script file somewhere on your `$PATH` and you're good to go.

# How To Use

## Alias

### `pcf alias [options]`

Create an alias for a specific PCF environment. The following options are available:

- `-n,--hostname OPSMAN_HOST`: Ops manager host or IP address
- `-u,--username OPSMAN_USER`: Ops manager admin username
- `-p,--password OPSMAN_PASSWORD`: Ops manager admin user's password
- `-o,--org CF_ORG`: Organization to log into with `cf login`. Defaults to `system`.
- `-s,--space CF_SPACE`: Space to log into with `cf login`. Defaults to `system`.

If Ops manager host, user, or password is omitted you will be prompted to enter it.

This command will only go so far as validating the connection to Ops Manager. Connections to bosh director, cloud controller, and UAA occur when executing `pcf target <alias>`.

Example:  `pcf alias -n 172.28.21.5 -u admin -p welcome -o system -s p-spring-cloud-services`

## Targets

### `pcf targets`

Displays a list of all available aliases that have been set up. The list reflect the contents of the `$HOME/.pcf/targets.json` file.

## Target

### `pcf target`

Display the current PCF environment target. Note that this command could reflect the wrong environment if you have run `bosh target`, `cf target`, or `uaac target` separately. When in doubt you should rerun `pcf target <alias>`.

### `pcf target <alias>`

Target a specific PCF environment whose name is `<alias>`. This will perform the following tasks:

- `cf login` to a specific org and space (system/system is the default)
- Obtain the ops manager director's root CA certificate and store it in `$HOME/.pcf/<alias>`
- `bosh target` the Ops Manager director with `director` credentials
- Download all bosh deployment manifests and store them in `$HOME/.pcf/<alias>/deployments`
- Set the current bosh deployment to the `cf` deployment
- Get the admin client token from the UAA server

After running this command you are able to run appropriate `cf`, `bosh`, and `uaac` commands for that PCF environment.

## Help

### `pcf help`

You can always get help by typing `pcf help`. It will list out all the available commands you can use.

### `pcf alias`

This will display help for the `alias` command with a description of all the options.

# Script Internals

All state associated with this script is stored in `$HOME/.pcf`. The contents of this directory include:

- `targets.json`: list of all target aliases in json format
- `<alias>` dirs: each <alias> has its own directory
- `<alias>/root_ca_certificate`: root CA certificate for connecting to the bosh director
- `<alias>/deployments`: contains manifests for all bosh deployments associated with the director making it easy to switch your deployment with `bosh deployment <manifest-file>`

# Future Directions

- Don't store ops man admin password in plain text in `$HOME/.pcf/targets.json`
- Vault support
- Use bosh v2
- More options
  - auto-target newly created alias
  - `cf login` as non-admin user
  - option to not always download bosh manifests
