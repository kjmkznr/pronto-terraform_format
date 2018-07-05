# frozen_string_literal: true

require 'pronto/terraform_format/wrapper'
require 'pronto'

module Pronto
  class TerraformFormatRunner < Runner
    def initialize(patches, commit = nil)
      super
      @inspector = ::Pronto::TerraformFormat::Wrapper.new
      if ENV['PRONTO_TERRAFORM_FORMAT_FILE_EXTS'].nil?
        @tf_extensions = %w[.tf .tfvars]
      else
        comma_separated_exts = ENV['PRONTO_TERRAFORM_FORMAT_FILE_EXTS']
        @tf_extensions = comma_separated_exts.split(',').map(&:strip)
      end
    end

    def run
      return [] if !@patches || @patches.count.zero?
      @patches
        .select { |p| tf_file?(p.new_file_full_path) }
        .map { |p| inspect(p) }
        .flatten.compact
        .uniq(&:line) # generate only one message per line
    end

    def inspect(patch)
      messages = []

      file_path = patch.new_file_full_path.to_s
      offences = @inspector.run(file_path)
      if not offences[file_path].nil?
        offences[file_path].each do |offence|
          messages += patch
            .added_lines
            .select { |line| line.new_lineno == offence[:line] }
            .map { |line| new_message(offence, line) }
        end
      end

      messages.compact
    end

    def tf_file?(file_path)
      @tf_extensions.include? File.extname(file_path)
    end

    def new_message(offence, line)
      Message.new(
        offence[:file],
        line,
        :warning,
        offence[:message],
        nil,
        self.class
      )
    end
  end
end
