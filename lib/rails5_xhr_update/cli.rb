# frozen_string_literal: true

require 'optparse'

module Rails5XHRUpdate
  # Provide the entry point to this program.
  class Cli
    def run
      parse_options
      paths.each do |path|
        buffer = Parser::Source::Buffer.new(path)
        buffer.read
        new_source = XHRToRails5.new.rewrite(
          buffer, Parser::CurrentRuby.new.parse(buffer)
        )
        output(new_source, path)
      end
      0
    end

    private

    def paths
      ARGV.empty? ? STDIN.read.split("\n") : ARGV
    end

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
        config.banner = <<~USAGE
          Usage: rails5_update.rb [options] FILE...

          Files can also be provided via stdin when not provided as a command line argument.
        USAGE
        config.on('-w', '--write', 'Write changes back to files') do |write|
          @options[:write] = write
        end
      end.parse!
    end
  end
end
