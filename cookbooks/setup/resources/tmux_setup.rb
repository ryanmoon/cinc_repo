# frozen_string_literal: true

#
# Cookbook:: setup
# Resource:: tmux
#
# Copyright:: 2023, moon, All Rights Reserved.

resource_name :tmux_setup
provides :tmux_setup

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
  # PLACE TEMPLATE
  #################

  template "#{new_resource.path}/.tmux.conf" do
    source 'tmux.conf.erb'
    user new_resource.user if new_resource.user
    group new_resource.group if new_resource.group
    mode '0755'
    action :create
  end

  package 'tmux' do
    action :install
  end

  execute 'Clone TMUX Plugins' do
    command 'git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm'
    action :run
    not_if { ::Dir.exist?("/home/#{new_resource.user}/.tmux/plugins/tpm") }
    not_if { ::Dir.exist?("/Users/#{new_resource.user}/.tmux/plugins/tpm") }
  end
end
