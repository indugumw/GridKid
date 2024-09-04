require_relative 'evaluator.rb'
require_relative 'ast.rb'
require_relative 'runtime.rb'

class Grid
    def initialize
      @cells = {}
      @evaluator = Evaluator.new
    end
  
    def set_cell(address, ast, source_code)
      model_primitive = ast.traverse(Evaluator.new, Runtime.new(self))
      
      @cells[address] = {
        source_code: source_code,
        abstract_syntax_tree: ast,
        model_primitive: model_primitive
      }
    end
  
    def get_cell(address)
      cell_data = @cells[address]
      return nil if cell_data.nil?
      
      cell_data[:model_primitive]
    end

    def get_source_code(address)
      cell_data = @cells[address]
      return nil if cell_data.nil?
      
      cell_data[:source_code]
    end
  end