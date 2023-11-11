# frozen_string_literal: true

#
# Cookbook:: setup
# Resource:: bash_profile
#
# Copyright:: 2023, moon, All Rights Reserved.

resource_name :bash_profile
provides :bash_profile

default_action :install

property :path, String, name_property: true
property :user, String, regex: Chef::Config[:user_valid_regex]
property :group, String, regex: Chef::Config[:group_valid_regex]

unified_mode true

#################
# INSTALL ACTION
#################

action :install do
  ######################
  # CREATE BASH PROFILE
  ######################

  template "#{new_resource.path}/.bash_profile" do
    source 'bash_profile.erb'
    user new_resource.user if new_resource.user
    group new_resource.group if new_resource.group
    mode '0755'
    variables(
      starship_path: new_resource.path
    )
    action :create
  end
end
