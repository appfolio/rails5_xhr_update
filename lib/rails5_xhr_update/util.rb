# frozen_string_literal: true

# Provide some helper methods to the module
module Rails5XHRUpdate
  def self.ast_pair(name, data)
    Parser::AST::Node.new(:pair, [Parser::AST::Node.new(:sym, [name]), data])
  end

  def self.ast_to_string(ast)
    string = Unparser.unparse(ast)[0..-2]
    string[string.index('(')] = ' '
    string
  end
end
