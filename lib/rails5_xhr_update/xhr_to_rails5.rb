# frozen_string_literal: true

require 'parser'
require 'unparser'

# Provide the XHRToRails5 class.
module Rails5XHRUpdate
  AST_TRUE = Parser::AST::Node.new(:true) # rubocop:disable Lint/BooleanSymbol)

  # Convert uses of the xhr method to use the rails 5 syntax.
  #
  # For example prior to rails 5 one might write:
  #
  #     xhr :get, images_path, limit: 10, sort: 'new'
  #
  # This class will convert that into:
  #
  #     get images_path, params: { limit: 10, sort: 'new' }, xhr: true
  class XHRToRails5 < Parser::TreeRewriter
    def on_send(node)
      return if node.children[1] != :xhr
      arguments = extract_and_validate_arguments(node)
      children = initial_children(node) + add_xhr_node(arguments)
      replace(node.loc.expression, Rails5XHRUpdate.ast_to_string(
                                     node.updated(nil, children)
      ))
    end

    private

    def add_xhr_node(arguments)
      children = []
      arguments.keys.sort.each do |argument|
        value = arguments[argument]
        children << Rails5XHRUpdate.ast_pair(argument, value) \
          unless value.nil? || value.children.empty?
      end
      children << Rails5XHRUpdate.ast_pair(:xhr, AST_TRUE)
      [Parser::AST::Node.new(:hash, children)]
    end

    def extract_and_validate_arguments(node)
      arguments = node.children[4..-1]
      if (keyword_arguments = handle_keyword_args(arguments))
        return keyword_arguments
      end
      raise Exception, "Unhandled:\n\n #{arguments}" if arguments.size > 3
      { params: arguments[0], session: arguments[1], flash: arguments[2] }
    end

    def initial_children(node)
      http_method = node.children[2].children[0]
      http_path = node.children[3]
      [nil, http_method, http_path]
    end

    def handle_keyword_args(arguments)
      return false if arguments.size != 1
      return false if arguments[0].children.empty?
      first_key = arguments[0].children[0].children[0].children[0]
      return false unless %i[params session flash format].include?(first_key)

      result = {}
      arguments[0].children.each do |node|
        raise Exception, "unexpected #{node}" if node.children.size != 2
        result[node.children[0].children[0]] = node.children[1]
      end
      result
    end
  end
end
