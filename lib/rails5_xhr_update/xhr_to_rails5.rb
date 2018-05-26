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
      children = initial_children(node) + add_xhr_node(*arguments)
      replace(node.loc.expression, Rails5XHRUpdate.ast_to_string(
                                     node.updated(nil, children)
      ))
    end

    private

    def add_xhr_node(params = nil, headers = nil)
      children = []
      children << Rails5XHRUpdate.ast_pair(:headers, headers) \
        unless headers.nil?
      children << Rails5XHRUpdate.ast_pair(:params, params) \
        unless params.nil? || params.children.empty?
      children << Rails5XHRUpdate.ast_pair(:xhr, AST_TRUE)
      [Parser::AST::Node.new(:hash, children)]
    end

    def extract_and_validate_arguments(node)
      arguments = node.children[4..-1]
      raise Exception, 'should this happen?' if new_syntax?(arguments)
      raise Exception "Unhandled:\n\n #{arguments}" if arguments.size > 2
      arguments
    end

    def initial_children(node)
      http_method = node.children[2].children[0]
      http_path = node.children[3]
      [nil, http_method, http_path]
    end

    def new_syntax?(arguments)
      return false if arguments.size != 1
      first_key = arguments[0].children[0].children[0].children[0]
      %i[params headers].include?(first_key)
    end
  end
end
