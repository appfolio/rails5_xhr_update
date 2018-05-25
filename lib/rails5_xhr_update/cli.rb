# frozen_string_literal: true

require 'optparse'

module Rails5XHRUpdate
  # Provide the entry point to this program.
  class Cli
    def output(source, path)
      if @options[:write]
        File.open(path, 'w') do |file|
          file.write(source)
        end
      else
        puts source
      end
    end

    def parse_options
      @options = {}
      OptionParser.new do |config|
        config.banner = 'Usage: rails5_update.rb [options] FILE...'
        config.on('-w', '--write', 'Write changes back to files') do |write|
          @options[:write] = write
        end
      end.parse!
    end

    def run
      parse_options
      ARGV.each do |path|
        buffer = Parser::Source::Buffer.new(path)
        buffer.read
        new_source = XHRToRails5.new.rewrite(
          buffer, Parser::CurrentRuby.new.parse(buffer)
        )
        output(new_source, path)
      end
      0
    end
  end
end
