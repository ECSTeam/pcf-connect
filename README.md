# Description

pcf-connect is a command line utility used to easily switch between PCF environments.

This script should function on both Mac OS X and Linux environments.

# Prerequisites

This script uses the following command line utilities:

- `jq` v1.4+
- `cf`
- `bosh` (optionally set `$BOSH_CMD` to an alternative command)
- `uaac` (optional)

# Installation

You don't need to `git clone` this entire repository. All that's needed is the `pcf` script itself.

Place the `pcf` script file somewhere on your `$PATH` and you're good to go.

# How To Use

## Alias

### `pcf alias <alias> [options]`

Create an alias for a specific PCF environment. The following options are available:

- `-n,--hostname OPSMAN_HOST`: Ops manager host or IP address
- `-u,--username OPSMAN_USER`: Ops manager admin username
- `-p,--password OPSMAN_PASSWORD`: Ops manager admin user's password
- `-o,--org CF_ORG`: Organization to log into with `cf login`. Defaults to `system`.
- `-s,--space CF_SPACE`: Space to log into with `cf login`. Defaults to `system`.

If Ops manager host, user, or password is omitted you will be prompted to enter it.

This command will only go so far as validating the connection to Ops Manager. Connections to bosh director, cloud controller, and UAA occur when executing `pcf target <alias>`.

Example:  `pcf alias dev -n 172.28.21.5 -u admin -p password -o system -s system`

## Targets

### `pcf targets`

Displays a list of all available aliases that have been set up. The list reflects the contents of the `$HOME/.pcf/targets.json` file.

## Target

### `pcf target`

Display the current PCF environment target. Note that this command could reflect the wrong environment if you have run `bosh target` (v1), `bosh alias-env` (v2), `cf target`, or `uaac target` separately. When in doubt you should rerun `pcf target <alias>`.

### `pcf target <alias>`

Target a specific PCF environment whose name is `<alias>`. This will perform the following tasks:

- `cf login` to org and space defined by `<alias>`
- Obtain the ops manager director's root CA certificate and store it in `$HOME/.pcf/<alias>`
- Log into the Ops Manager director with `director` credentials
- Download all bosh deployment manifests and store them in `$HOME/.pcf/<alias>/deployments`
- Set the current bosh deployment to the `cf` deployment (bosh v1 only)
- Get the admin client token from the UAA server (if `uaac` is installed)

After running this command you are able to run appropriate `cf`, `bosh`, and `uaac` commands for that PCF environment.

NOTE:  `pcf` will use whatever version of the Bosh CLI `bosh -v` returns. If you would like to change this to use a command other than `bosh` (e.g. `bosh2`) you can set an environment variable, `BOSH_CMD`, to your custom name.

## Help

### `pcf help`

You can get help by typing `pcf help`. It will list out all the available commands you can use.

### `pcf alias`

This will display help for the `alias` command with a description of all the options.

# Script Internals

All state associated with this script is stored in `$HOME/.pcf`. The contents of this directory include:

- `targets.json`: list of all target aliases in json format
- `<alias>` dirs: each <alias> has its own directory
- `<alias>/root_ca_certificate`: root CA certificate for connecting to the bosh director
- `<alias>/deployments`: contains manifests for all bosh deployments associated with the director making it easy to switch your deployment with `bosh deployment <manifest-file>` (v1)

# Future Directions

- Don't store ops man admin password in plain text in `$HOME/.pcf/targets.json`
- Vault support
- Make `pcf target` and `pcf targets` more informative
- More options
  - auto-target newly created alias
  - `cf login` as non-admin user
  - option to not always download bosh manifests
