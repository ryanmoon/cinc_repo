# frozen_string_literal: true

#
# Cookbook:: setup
# Resource:: basics
#
# Copyright:: 2023, moon, All Rights Reserved.

resource_name :basics
provides :basics

unified_mode true

action :install do
  build_essential 'install_tools' do
    compile_time true
    action :install
  end
end
