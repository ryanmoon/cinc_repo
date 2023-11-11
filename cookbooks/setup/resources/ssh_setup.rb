# frozen_string_literal: true

#
# Cookbook:: setup
# Resource:: ssh_keys
#
# Copyright:: 2023, moon, All Rights Reserved.

resource_name :ssh_setup
provides :ssh_setup

default_action :install

property :path, String, name_property: true
property :user, String, regex: Chef::Config[:user_valid_regex]
property :group, String, regex: Chef::Config[:group_valid_regex]
unified_mode true

#################
# INSTALL ACTION
#################

action :install do
  #################
  # CREATE SSH DIR
  #################

  directory "#{new_resource.path}/.ssh" do
    user new_resource.user if new_resource.user
    group new_resource.group if new_resource.group
    mode '0755'
    action :create
  end

  execute 'Curl Github Keys' do
    command "curl https://github.com/ryanmoon.keys > #{new_resource.path}/.ssh/authorized_keys"
    action :run
  end
end
