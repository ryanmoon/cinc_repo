# frozen_string_literal: true

#
# Cookbook:: setup
# Resource:: starship_setup
#
# Copyright:: 2023, moon, All Rights Reserved.

resource_name :starship_setup
provides :starship_setup

default_action :install

property :path, String, name_property: true
property :user, String, regex: Chef::Config[:user_valid_regex]
property :group, String, regex: Chef::Config[:group_valid_regex]
unified_mode true

#################
# INSTALL ACTION
#################

action :install do
  ################################
  # PLACE STARSHIP INSTALL SCRIPT
  ################################

  execute 'Pull down latest' do
    command 'curl -sS https://starship.rs/install.sh -o /opt/starship'
    action :run
  end

  execute 'Install Starship' do
    command 'sh /opt/starship -y'
    action :run
  end

  ##############
  # CONFIG FILE
  ##############

  template "#{new_resource.path}/starship.toml" do
    source 'starship.toml.erb'
    user new_resource.user if new_resource.user
    group new_resource.group if new_resource.group
    mode '0644'
    action :create
  end
end
