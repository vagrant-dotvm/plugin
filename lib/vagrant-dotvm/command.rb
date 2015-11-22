require 'fileutils'

module VagrantPlugins
  module Dotvm
    class Command < Vagrant.plugin(2, :command)
      COMMANDS = %w(init)

      def self.synopsis
        'manages DotVM configuration'
      end

      def execute
        opts = OptionParser.new do |o|
          o.banner = sprintf 'Usage: vagrant dotvm <%s>', COMMANDS.join('|')
          o.separator ''

          o.on('-h', '--help', 'Print this help') do
            safe_puts(opts.help)
            return nil
          end
        end

        argv = parse_options(opts)
        command = argv[0]

        if !command || !COMMANDS.include?(command)
          safe_puts opts.help
          return nil
        end

        send("command_#{command}")
      end

      private

      def command_init
        if File.exist? "#{FileUtils.pwd}/Vagrantfile"
          fail Vagrant::Errors::VagrantError.new, 'DotVM: Refusing to init in this directory, Vagrantfile already exists.'
        end

        unless (Dir.entries(FileUtils.pwd) - %w(. ..)).empty?
          @env.ui.warn 'DotVM: Directory is not empty, result is undefined.'
        end

        FileUtils.cp_r "#{SKEL_PATH}/.", FileUtils.pwd
      end
    end
  end
end
