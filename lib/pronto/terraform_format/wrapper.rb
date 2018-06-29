require 'open3'
require_relative 'output_parser'

module Pronto
  module TerraformFormat
    class Wrapper
      def initialize
        @terraform_path = ENV['PRONTO_TERRAFORM_PATH'] || 'terraform'
      end

      def run(file_path)
        stdout, stderr, = Open3.capture3("#{@terraform_path} "\
                                         "fmt "\
                                         "-write=false "\
                                         "-list=false "\
                                         "-diff=true "\
                                         "-check=false "\
                                         "#{file_path}")
        if stderr && !stderr.empty?
          puts "WARN: pronto-terraform_format: #{file_path}: #{stderr}"
        end
        return [] if stdout.nil? || stdout == 0
        OutputParser.new.parse(file_path, stdout)
      end
    end
  end
end
