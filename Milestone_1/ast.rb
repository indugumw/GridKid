require_relative 'serializer.rb'
require_relative 'evaluator.rb'

# Primitives
class IntegerPrimitive
    attr_reader :value, :start_index, :end_index
  
    def initialize(value, start_index, end_index)
      @value = value
      @start_index = start_index
      @end_index = end_index
    end
  
    def traverse(visitor, payload)
      visitor.visit_integer(self)
    end

    def to_f
      @value.to_f
    end
end

class FloatPrimitive
  attr_reader :value, :start_index, :end_index

  def initialize(value, start_index, end_index)
    @value = value
    @start_index = start_index
    @end_index = end_index
  end

  def traverse(visitor, payload)
    visitor.visit_float(self)
  end

  def to_i
    @value.to_i
  end
end

class BooleanPrimitive
  attr_reader :value, :start_index, :end_index

  def initialize(value, start_index, end_index)
    @value = value
    @start_index = start_index
    @end_index = end_index
  end

  def traverse(visitor, payload)
    visitor.visit_float(self)
  end
end

class StringPrimitive
  attr_reader :value, :start_index, :end_index

  def initialize(value, start_index, end_index)
    @value = value
    @start_index = start_index
    @end_index = end_index
  end

  def traverse(visitor, payload)
    visitor.visit_string(self)
  end
end

  class CellAddressPrimitive
    attr_reader :row, :column, :start_index, :end_index

    def initialize(row, column, start_index, end_index)
      @row = row
      @column = column
      @start_index = start_index
      @end_index = end_index
    end

    def traverse(visitor, payload)
      visitor.visit_cell_address(self, payload)
    end
end

# Arithmetic Operations
class Add
    attr_reader :left, :right, :start_index, :end_index
  
    def initialize(left, right, start_index, end_index)
      @left = left
      @right = right
      @start_index = start_index
      @end_index = end_index
    end
  
    def traverse(visitor, payload)
      visitor.visit_add(self, payload)
    end
end

class Subtract
    attr_reader :left, :right, :start_index, :end_index
  
    def initialize(left, right, start_index, end_index)
      @left = left
      @right = right
      @start_index = start_index
      @end_index = end_index
    end
  
    def traverse(visitor, payload)
      visitor.visit_subtract(self, payload)
    end
end

class Multiply
  attr_reader :left, :right, :start_index, :end_index

  def initialize(left, right, start_index, end_index)
    @left = left
    @right = right
    @start_index = start_index
    @end_index = end_index
  end

  def traverse(visitor, payload)
    visitor.visit_multiply(self, payload)
  end
end

class Divide
  attr_reader :left, :right, :start_index, :end_index

  def initialize(left, right, start_index, end_index)
    @left = left
    @right = right
    @start_index = start_index
    @end_index = end_index
  end

  def traverse(visitor, payload)
    visitor.visit_divide(self, payload)
  end
end

class Modulo
  attr_reader :left, :right, :start_index, :end_index

  def initialize(left, right, start_index, end_index)
    @left = left
    @right = right
    @start_index = start_index
    @end_index = end_index
  end

  def traverse(visitor, payload)
    visitor.visit_modulo(self, payload)
  end
end

class Exponentiation
  attr_reader :left, :right, :start_index, :end_index

  def initialize(left, right, start_index, end_index)
    @left = left
    @right = right
    @start_index = start_index
    @end_index = end_index
  end

  def traverse(visitor, payload)
    visitor.visit_exponentiation(self, payload)
  end
end

class Negation
  attr_reader :node, :start_index, :end_index

  def initialize(node, start_index, end_index)
    @node = node
    @start_index = start_index
    @end_index = end_index
  end

  def traverse(visitor, payload)
    visitor.visit_negation(self, payload)
  end
end

# Logical Operations
class Logical_And
    attr_reader :left, :right, :start_index, :end_index
  
    def initialize(left, right, start_index, end_index)
      @left = left
      @right = right
      @start_index = start_index
      @end_index = end_index
    end

    def traverse(visitor, payload)
        visitor.visit_logical_and(self, payload)
    end
  end
  
  class Logical_Or
    attr_reader :left, :right, :start_index, :end_index
  
    def initialize(left, right, start_index, end_index)
      @left = left
      @right = right
      @start_index = start_index
      @end_index = end_index
    end

    def traverse(visitor, payload)
        visitor.visit_logical_or(self, payload)
    end
  end

  class Logical_Not
    attr_reader :operand, :start_index, :end_index
  
    def initialize(operand, start_index, end_index)
      @operand = operand
      @start_index = start_index
      @end_index = end_index
    end

    def traverse(visitor, payload)
        visitor.visit_logical_not(self, payload)
    end
  end

# Cell Values
class CellLvalue
    attr_reader :address_row, :address_col, :start_index, :end_index
    
    def initialize(address_row, address_col, start_index, end_index)
      @address_row = address_row
      @address_col = address_col
      @start_index = start_index
      @end_index = end_index
    end

    def traverse(visitor, payload)
        visitor.visit_lvalue(self, payload)
      end
end
  
class CellRvalue
    attr_reader :address_row, :address_col, :start_index, :end_index
    
    def initialize(address_row, address_col, start_index, end_index)
      @address_row = address_row
      @address_col = address_col
      @start_index = start_index
      @end_index = end_index
    end

    def traverse(visitor, payload)
        visitor.visit_rvalue(self, payload)
      end
end

# Bitwise Operations
class Bitwise_And
    attr_reader :left, :right, :start_index, :end_index
  
    def initialize(left, right, start_index, end_index)
      @left = left
      @right = right
      @start_index = start_index
      @end_index = end_index
    end

    def traverse(visitor, payload)
        visitor.visit_bitwise_and(self, payload)
    end
end
  
class Bitwise_Or
    attr_reader :left, :right, :start_index, :end_index
  
    def initialize(left, right, start_index, end_index)
      @left = left
      @right = right
      @start_index = start_index
      @end_index = end_index
    end

    def traverse(visitor, payload)
        visitor.visit_bitwise_or(self, payload)
    end
end

class Bitwise_Xor
  attr_reader :left, :right, :start_index, :end_index

  def initialize(left, right, start_index, end_index)
    @left = left
    @right = right
    @start_index = start_index
    @end_index = end_index
  end

  def traverse(visitor, payload, start_index, end_index)
      visitor.visit_bitwise_xor(self, payload)
  end
end

class Bitwise_Not
    attr_reader :operand, :start_index, :end_index
  
    def initialize(operand, start_index, end_index)
      @operand = operand
      @start_index = start_index
      @end_index = end_index
    end

    def traverse(visitor, payload)
        visitor.visit_bitwise_not(self, payload)
    end
end

class Left_Shift
    attr_reader :operand, :amount, :start_index, :end_index
  
    def initialize(operand, amount, start_index, end_index)
      @operand = operand
      @amount = amount
      @start_index = start_index
      @end_index = end_index
    end

    def traverse(visitor, payload)
        visitor.visit_left_shift(self, payload)
    end
end

class Right_Shift
    attr_reader :operand, :amount, :start_index, :end_index
  
    def initialize(operand, amount, start_index, end_index)
      @operand = operand
      @amount = amount
      @start_index = start_index
      @end_index = end_index
    end

    def traverse(visitor, payload)
        visitor.visit_right_shift(self, payload)
    end
end

# Relational Operations
class Equals
    attr_reader :left, :right, :start_index, :end_index
  
    def initialize(left, right, start_index, end_index)
      @left = left
      @right = right
      @start_index = start_index
      @end_index = end_index
    end

    def traverse(visitor, payload)
        visitor.visit_equals(self, payload)
    end
end
  
class Not_Equals
    attr_reader :left, :right, :start_index, :end_index
  
    def initialize(left, right, start_index, end_index)
      @left = left
      @right = right
      @start_index = start_index
      @end_index = end_index
    end

    def traverse(visitor, payload)
        visitor.visit_not_equals(self, payload)
    end
end

class Less_Than
  attr_reader :left, :right, :start_index, :end_index

  def initialize(left, right, start_index, end_index)
    @left = left
    @right = right
    @start_index = start_index
    @end_index = end_index
  end

  def traverse(visitor, payload)
      visitor.visit_less_than(self, payload)
  end
end

class Less_Than_Equal_to
  attr_reader :left, :right, :start_index, :end_index

  def initialize(left, right, start_index, end_index)
    @left = left
    @right = right
    @start_index = start_index
    @end_index = end_index
  end

  def traverse(visitor, payload)
      visitor.visit_less_than_equal_to(self, payload)
  end
end

class Greater_Than
  attr_reader :left, :right, :start_index, :end_index

  def initialize(left, right, start_index, end_index)
    @left = left
    @right = right
    @start_index = start_index
    @end_index = end_index
  end

  def traverse(visitor, payload)
      visitor.visit_greater_than(self, payload)
  end
end

class Greater_Than_Equal_To
  attr_reader :left, :right, :start_index, :end_index

  def initialize(left, right, start_index, end_index)
    @left = left
    @right = right
    @start_index = start_index
    @end_index = end_index
  end

  def traverse(visitor, payload)
      visitor.visit_greater_than_equal_to(self, payload)
  end
end

# Casting Operators
class FloatToInt
    attr_reader :value, :start_index, :end_index
    
    def initialize(value, start_index, end_index)
      @value = value
      @start_index = start_index
      @end_index = end_index
    end
    
    def traverse(visitor, payload)
      visitor.visit_float_to_int(self, payload)
    end
  end
  
  class IntToFloat
    attr_reader :value, :start_index, :end_index
  
  def initialize(value, start_index, end_index)
    @value = value
    @start_index = start_index
    @end_index = end_index
  end
  
  def traverse(visitor, payload)
    visitor.visit_int_to_float(self, payload)
  end
end

# Statistical Functions
class Max
    attr_reader :left, :right, :start_index, :end_index
    
    def initialize(left, right, start_index, end_index)
      @left = left
      @right = right
      @start_index = start_index
      @end_index = end_index
    end
    
    def traverse(visitor, payload)
      visitor.visit_max(self, payload)
    end
  end
  
  class Min
    attr_reader :left, :right, :start_index, :end_index
    
    def initialize(left, right, start_index, end_index)
      @left = left
      @right = right
      @start_index = start_index
      @end_index = end_index
    end
    
    def traverse(visitor, payload)
      visitor.visit_min(self, payload)
    end
  end
  
  class Mean
    attr_reader :left, :right, :start_index, :end_index
    
    def initialize(left, right, start_index, end_index)
      @left = left
      @right = right
      @start_index = start_index
      @end_index = end_index
    end
    
    def traverse(visitor, payload)
      visitor.visit_mean(self, payload)
    end
  end
  
  class Sum
    attr_reader :left, :right, :start_index, :end_index
    
    def initialize(left, right, start_index, end_index)
      @left = left
      @right = right
      @start_index = start_index
      @end_index = end_index
    end
    
    def traverse(visitor, payload)
      visitor.visit_sum(self, payload)
    end
  end