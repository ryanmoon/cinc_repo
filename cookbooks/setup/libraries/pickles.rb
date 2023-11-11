# frozen_string_literal: true

require 'chef/mixin/shell_out'

# Chef Infra Documentation
# https://docs.chef.io/libraries/
#

#
# This module name was auto-generated from the cookbook name. This name is a
# single word that starts with a capital letter and then continues to use
# camel-casing throughout the remainder of the name.
#
module Setup
  module Pickles
    include Chef::Mixin::ShellOut

    ##################
    # MACOS USER INFO
    ##################

    def macos_display_name
      Etc.getpwuid(::File.stat('/dev/console').uid).gecos
    end

    def macos_user
      Etc.getpwuid(::File.stat('/dev/console').uid).name
    end

    def macos_user_id
      Etc.getpwuid(::File.stat('/dev/console').uid).uid
    end

    def macos_user_gid
      Etc.getpwuid(::File.stat('/dev/console').uid).gid
    end

    def macos_user_shell
      Etc.getpwuid(::File.stat('/dev/console').uid).shell
    end

    ##################
    # LINUX USER INFO
    ##################

    def linux_user
      Etc.getpwuid.name
    end

    def linux_user_id
      Etc.getpwuid.uid
    end

    def linux_user_gid
      Etc.getpwuid.gid
    end

    def linux_user_shell
      Etc.getpwuid.shell
    end

    ###########
    # HOMEBREW
    ###########

    def macos_homebrew_intel
      File.exist?('/usr/local/bin/brew')
    end

    def macos_homebrew_apple_arm
      File.exist?('/opt/homebrew/bin/brew')
    end

    def linux_homebrew
      File.exist?('/home/linuxbrew/.linuxbrew/bin/brew')
    end

    def homebrew_present?
      macos_homebrew_apple_arm || macos_homebrew_intel || linux_homebrew
    end

    #################################
    # MAKE CALLING POWERSHELL EASIER
    #################################

    def powershell_wrapper
      'powershell.exe -NoLogo -NonInteractive -NoProfile -InputFormat none -Command'
    end

    ################
    # PROFILES HELP
    ################

    def macos_profiles
      string = Mixlib::ShellOut.new('/usr/bin/profiles -C -o stdout-xml').run_command.stdout.strip
      Plist.parse_xml(string)
    end

    #########
    # MOJAVE
    #########

    def macos_mojave?
      @macos_mojave ||= macos? && node['platform_version'].to_f == 10.14
    end

    ###########
    # CATALINA
    ###########

    def macos_catalina?
      @macos_catalina ||= macos? && node['platform_version'].to_f == 10.15
    end

    ##########
    # BIG SUR
    ##########

    def macos_big_sur?
      @macos_big_sur ||= macos? && node['platform_version'].to_i == 11
    end

    ###########
    # MONTEREY
    ###########

    def macos_monterey?
      @macos_monterey ||= macos? && node['platform_version'].to_i == 12
    end

    ##########
    # VENTURA
    ##########

    def macos_ventura?
      @macos_ventura ||= macos? && node['platform_version'].to_i == 13
    end

    ##########################
    # MACOS APPLE SILICON CPU
    ##########################

    def apple_silicon?
      if macos?
        @apple_silicon ||= shell_out(
          '/usr/sbin/sysctl machdep.cpu.brand_string'
        ).stdout.include?('Apple')
      end
    end

    #############
    # MACOS ARCH
    #############

    def macos_architecture
      if macos?
        shell_out(
          '/usr/bin/arch'
        ).stdout.strip
      end
    end

    ######################
    # MACOS SYSPREF VALUE
    ######################

    def macos_preference_value(preference, domain)
      value = shell_out("/usr/bin/python -c \"import Foundation; import sys; value = Foundation.CFPreferencesCopyAppValue('#{preference}', '#{domain}'); out = value or ''; sys.stdout.write(out);\"").stdout.split("\n").join
      if value == ''
        nil
      else
        value
      end
    end

    ########################
    # MACOS PROCESS RUNNING
    ########################

    def macos_process_running?(process)
      if macos?
        begin
          cmd = "/usr/bin/pgrep -xq \"#{process}\""
          cmd_out = Mixlib::ShellOut.new(
            cmd.to_s
          ).run_command
          cmd_out.exitstatus == 0
        rescue Mixlib::ShellOut::CommandTimeout => e
          Chef::Log.warn("CpeHelpers macos_process_running Timeout Error: #{e.message}")
        rescue Mixlib::ShellOut::ShellCommandFailed => e
          Chef::Log.warn("CpeHelpers macos_process_running shell command failed error: #{e.message}")
        end
      end
    end

    ################
    # OSQUERY QUERY
    ################

    def osquery_query(query, format = 'json')
      if Chef.node['platform'] == 'windows'
        [
          'C:\\Program Files\\osquery\\osqueryi.exe',
          'C:\\ProgramData\\osquery\\osqueryi.exe',
        ].each do |path|
          if File.exist?(path)
            @osquery_bin = path
            break
          end
        end
      else
        [
          '/usr/bin/osqueryi',
          '/usr/local/bin/osqueryi',
        ].each do |path|
          if File.exist?(path)
            @osquery_bin = path
            break
          end
        end
      end
      @query = query.tr("\n", ' ')
      results = []
      begin
        osquery_cmd = "\"#{@osquery_bin}\" --disable_extensions \"#{@query}\""
        case format
        when 'json'
          response = Mixlib::ShellOut.new(
            "#{osquery_cmd} --json"
          ).run_command.stdout.strip
          results = JSON.parse(response)
        when 'list'
          results = Mixlib::ShellOut.new(
            "#{osquery_cmd} --list --header=0"
          ).run_command.stdout.split("\n")
        end
      rescue JSON::ParserError => e
        Chef::Log.warn("CpeHelpers Osquery Parse Error: #{e.message}")
        results = []
      rescue Mixlib::ShellOut::CommandTimeout => e
        Chef::Log.warn("CpeHelpers Osquery Timeout Error: #{e.message}")
        results = []
      end
      results
    end

    ##########################
    # WINDOWS SERVICE HELPERS
    ##########################

    def moon_windows_service(service_name_status)
      ######################
      # JUST RETURNS STATUS
      ######################
      shell_out("#{powershell_wrapper} (Get-Service -Name #{service_name_status}).Status").stdout.chomp
    end

    def moon_windows_service_running?(service_name_status)
      ########################
      # RETURNS TRUE OR FALSE
      ########################
      shell_out("#{powershell_wrapper} (Get-Service -Name #{service_name_status}).Status").stdout.include? 'Running'
    end

    def moon_windows_service_stopped?(service_name_status)
      ########################
      # RETURNS TRUE OR FALSE
      ########################
      shell_out("#{powershell_wrapper} (Get-Service -Name #{service_name_status}).Status").stdout.include? 'Stopped'
    end

    def moon_windows_service_path_present?(service_path)
      #########################################
      # FULL OR PARITAL PATH NEEDED FOR SEARCH
      # RETURNS TRUE OR FALSE
      #########################################
      shell_out("#{powershell_wrapper} (Get-CimInstance -ClassName win32_service).PathName").stdout.include? service_path.to_s
    end

    #####################
    # OS VERSION SUPPORT
    #####################

    def os_at_least?(version)
      Gem::Version.new(node['platform_version']) >= Gem::Version.new(version)
    end

    def os_at_most?(version)
      Gem::Version.new(node['platform_version']) <= Gem::Version.new(version)
    end

    def os_greater_than?(version)
      Gem::Version.new(node['platform_version']) > Gem::Version.new(version)
    end

    def os_less_than?(version)
      Gem::Version.new(node['platform_version']) < Gem::Version.new(version)
    end
  end
end

Chef::DSL::Universal.include Setup::Pickles
