#
# Cookbook:: setup
# Recipe:: default
#
# Copyright:: 2023, moon, All Rights Reserved.

###################################
# INCLUDE PLATFORM SPECIFIC RECIPE
###################################

include_recipe "setup::#{node['platform_family']}_setup"
