#
# Cookbook:: setup
# Recipe:: mac_os_x_setup
#
# Copyright:: 2023, moon, All Rights Reserved.

#########
# BASICS
#########

basics 'setup basics' do
  action :install
end

###########
# SSH KEYS
###########

ssh_setup 'enable ssh keys' do
  action :install
end

###########
# STARSHIP
###########

starship_setup 'setup' do
  action :install
end

################
# SHELL_PROFILE
################

bash_profile 'setup' do
  action :install
end

#######
# TMUX
#######

tmux_setup 'setup' do
  action :install
end
