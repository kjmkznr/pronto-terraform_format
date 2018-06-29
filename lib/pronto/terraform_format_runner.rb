require 'pronto/terraform_format/wrapper'
require 'pronto'

module Pronto
  class TerraformFormatRunner < Runner
    def initialize(_, __ = nil)
      super
      @inspector = ::Pronto::TerraformFormat::Wrapper.new
      comma_separated_exts = ENV['PRONTO_TERRAFORM_FORMAT_FILE_EXTS']
      if comma_separated_exts.nil? # load default tf files extensions
        @tf_extensions = %w[.tf .tfvars]
      else # load desired extensions from environment variable
        @tf_extensions = comma_separated_exts.split(',').map(&:strip)
      end
    end

    def run
      return [] if !@patches || @patches.count.zero?
      @patches
        .select { |p| tf_file?(p.new_file_full_path) }
        .map { |p| inspect(p) }
        .flatten.compact
        .uniq { |message| message.line } # generate only one message per line
    end

    def inspect(patch)
      messages = []

      file_path = patch.new_file_full_path.to_s
      offences = @inspector.run(file_path)
      offences[file_path].each do |offence|
        messages += patch
          .added_lines
          .select { |line| line.new_lineno == offence[:line] }
          .map { |line| new_message(offence, line) }
      end

      messages.compact
    end

    def tf_file?(file_path)
      @tf_extensions.include? File.extname(file_path)
    end

    def new_message(offence, line)
      Message.new(offence[:file], line, :warning, offence[:message], nil, self.class)
    end
  end
end
