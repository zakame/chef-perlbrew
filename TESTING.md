# How to test chef-perlbrew

## Testing prerequisites

- A working ChefDK or Chef Workstation
- Hashicorp's Vagrant (requires a working provider such as Oracle
  Virtualbox, or KVM via libvirt)

## Installing dependencies

To install cookbook dependencies for integration testing, do

    chef exec berks install

## Cookbook testing

To check for cookbook lint, do

    chef exec cookstyle .

To check for cookbook common problems such as using deprecated forms and
correctness, do

    chef exec foodcritic .

## Integration testing

To see a list of available instances, do

    chef exec kitchen list

To run tests against all available instances, do

    chef exec kitchen test

To run tests against a specific instance, do

    chef exec kitchen test INSTANCE_NAME
