require 'thor'
require 'securerandom'
require 'fileutils'

require_relative 'launch_helper'
require_relative 'ansible_helper'

module OpenShift
  module Ops
    class LanCommand < Thor
      # WARNING: we do not currently support environments with hyphens in the name
      SUPPORTED_ENVS = %w(prod stg int tint kint test jint amint tdint lint) << ENV['OO_CUSTOM_ENV']

      option :type, :required => true, :enum => LaunchHelper.get_lan_host_types,
             :desc => 'The type of the instances to configure.'
      option :env, :required => true, :aliases => '-e', :enum => SUPPORTED_ENVS,
             :desc => 'The environment of the new instances.'
      option :count, :aliases => '-c'
      option :skip_config, :type => :boolean
      desc "launch", 'Launches instances.'
      def launch()
        ah = AnsibleHelper.for_lan()
				ah.verbosity = ''

        host_type = options[:type]

        ah.extra_vars['oo_env'] = options[:env]

        File.open('local_ansible_inventory.ini', 'w') do |file|
          file.puts('[tag_env-host-type_%s-openshift-master]' % options[:env])
          ENV['MASTERS'].split(/, ?/).each do |master|
            file.puts(master)
          end
          file.puts('[tag_env-host-type_%s-openshift-minion]' % options[:env])
          ENV['MINIONS'].split(/, ?/).each_with_index do |minion, index|
            file.puts('%s oo_minion_subnet_index=%i' % [minion, index])
          end
        end

        # Check if we install a custom openshift
        if !ENV['OO_OPENSHIFT_BINARY'].nil?
          ah.extra_vars['oo_openshift_binary'] = File.expand_path(ENV['OO_OPENSHIFT_BINARY'])
        end

        ah.run_playbook("playbooks/lan/#{host_type}/launch.yml")
      end

      option :type, :required => true, :enum => LaunchHelper.get_lan_host_types,
             :desc => 'The type of the instances to configure.'
      option :env, :required => true, :aliases => '-e', :enum => SUPPORTED_ENVS,
             :desc => 'The environment of the new instances.'
      desc "config", 'Configure instances.'
      def config()
        ah = AnsibleHelper.for_lan()
        ah.verbosity = ''

        host_type = options[:type]

        ah.extra_vars['oo_env'] = options[:env]

        # Check if we install a custom openshift
        if !ENV['OO_OPENSHIFT_BINARY'].nil?
          ah.extra_vars['oo_openshift_binary'] = File.expand_path(ENV['OO_OPENSHIFT_BINARY'])
        end

        ah.run_playbook("playbooks/lan/#{host_type}/config.yml")
      end
    end
  end
end
