#
# Cookbook:: setup
# Recipe:: debian_setup
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
  path '/home/moon'
  user 'moon'
  group 'moon'
  action :install
end

###########
# STARSHIP
###########

starship_setup 'setup' do
  path '/home/moon'
  user 'moon'
  group 'moon'
  action :install
end

################
# SHELL_PROFILE
################

bash_profile 'setup' do
  path '/home/moon'
  user 'moon'
  group 'moon'
  action :install
end

#######
# TMUX
#######

tmux_setup 'setup' do
  path '/home/moon'
  user 'moon'
  group 'moon'
  action :install
end
