# frozen_string_literal: true

require 'unified_diff'

module Pronto
  module TerraformFormat
    class OutputParser
      def parse(file_path, output)
        begin
          # skip first line
          diff = UnifiedDiff.parse(output.lines[3..output.lines.length].join(''))
        rescue StandardError => e
          puts "pronto-terraform_format ERROR: failed to parse output. #{e}"
          return {}
        end

        result = {}
        diff.chunks.each do |chunk|
          file = file_path
          result[file] ||= []
          result[file] << {
            file: file,
            line: chunk.modified_range.min,
            message: 'Needs to run terraform fmt'
          }
        end
        result
      end
    end
  end
end
