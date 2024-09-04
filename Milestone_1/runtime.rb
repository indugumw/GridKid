require_relative 'ast.rb'
require_relative 'grid.rb'

class Runtime
    attr_reader :grid
  
    def initialize(grid)
      @grid = grid
    end
  
    def get_cell_value(address)
      @grid.get_cell(address)
    end

    def get_source_code(address)
      @grid.get_source_code(address)
    end

    def set_cell(address, source_code, ast)
      @grid.set_cell(address, source_code, ast)
    end
  end