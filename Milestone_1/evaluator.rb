require_relative 'ast.rb'

class Evaluator
    def evaluate(node, runtime)
        node.traverse(self, runtime)
    end

    ''' Cell Values'''
    def visit_lvalue(node, runtime)
        cp = node.address_col.traverse(self, runtime)
        rp = node.address_row.traverse(self, runtime)

        unless cp.is_a?(IntegerPrimitive) and rp.is_a?(IntegerPrimitive)
            raise "Operands must be IntegerPrimitives"
        end

        cell_address = CellAddressPrimitive.new(rp.value, cp.value, rp.start_index, cp.end_index)
        cell_address
    end

    def visit_rvalue(node, runtime)
        cp = node.address_col.traverse(self, runtime)
        rp = node.address_row.traverse(self, runtime)

        unless cp.is_a?(IntegerPrimitive) and rp.is_a?(IntegerPrimitive)
            raise "Operands must be IntegerPrimitives"
        end

        cell_value = runtime.get_cell_value([rp.value, cp.value])
        cell_value
    end

    ''' Primitives'''
    def visit_integer(node)
      node
    end

    def visit_float(node)
        node
    end

    def visit_string(node)
        node
    end

    def visit_cell_address(node, runtime)
        cp = node.column.traverse(self, runtime)
        rp = node.row.traverse(self, runtime)

        unless cp.is_a?(IntegerPrimitive) and rp.is_a?(IntegerPrimitive)
            raise "Operands must be IntegerPrimitives"
        end

        cell_address = CellAddressPrimitive.new(rp.value, cp.value, rp.start_index, cp.end_index)
        cell_address
    end

    ''' Helper Functions'''
    def is_number(value)
        value.is_a?(IntegerPrimitive) || value.is_a?(FloatPrimitive)
    end

    def visit_print(node)
        primitive = node.operand.traverse(self, nil)
    end
  
    ''' Arithmetic Operations'''
    def visit_add(node, runtime)
        left_value = node.left.traverse(self, runtime)
        right_value = node.right.traverse(self, runtime)

        # unless is_number(left_value) && is_number(right_value)
        #     raise "Addition operands must be Numbers"
        # end

        result = left_value.value + right_value.value
        if left_value.is_a?(IntegerPrimitive) && right_value.is_a?(IntegerPrimitive)
            result = IntegerPrimitive.new(result, left_value.start_index, right_value.end_index)
          else
            result = FloatPrimitive.new(result, left_value.start_index, right_value.end_index)
          end

        result
    end

    def visit_subtract(node, runtime)
        left_value = node.left.traverse(self, runtime)
        right_value = node.right.traverse(self, runtime)

        unless is_number(left_value) && is_number(right_value)
            raise "Subtraction operands must be Numbers"
        end

        result = left_value.value - right_value.value
        if left_value.is_a?(IntegerPrimitive) && right_value.is_a?(IntegerPrimitive)
            result = IntegerPrimitive.new(result.to_i, left_value.start_index, right_value.end_index)
          else
            result = FloatPrimitive.new(result.to_f, left_value.start_index, right_value.end_index) 
          end

        result
    end

    def visit_multiply(node, runtime)
        left_value = node.left.traverse(self, runtime)
        right_value = node.right.traverse(self, runtime)

        unless is_number(left_value) && is_number(right_value)
            raise "Multiplication operands must be Numbers"
        end

        result = left_value.value * right_value.value
        if left_value.is_a?(IntegerPrimitive) && right_value.is_a?(IntegerPrimitive)
            result = IntegerPrimitive.new(result.to_i, left_value.start_index, right_value.end_index) 
          else
            result = FloatPrimitive.new(result.to_f, left_value.start_index, right_value.end_index)
          end

        result
    end

    def visit_divide(node, runtime)
        left_value = node.left.traverse(self, runtime)
        right_value = node.right.traverse(self, runtime)

        unless is_number(left_value) && is_number(right_value)
            raise "Division operands must be Numbers"
        end

        result = left_value.value / right_value.value
        if left_value.is_a?(IntegerPrimitive) && right_value.is_a?(IntegerPrimitive)
            result = IntegerPrimitive.new(result.to_i, left_value.start_index, right_value.end_index)
          else
            result = FloatPrimitive.new(result.to_f, left_value.start_index, right_value.end_index)
          end

        result
    end

    def visit_modulo(node, runtime)
        left_value = node.left.traverse(self, runtime)
        right_value = node.right.traverse(self, runtime)

        unless is_number(left_value) && is_number(right_value)
            raise "Modulo operands must be Numbers"
        end

        result = left_value.value % right_value.value
        if left_value.is_a?(IntegerPrimitive) && right_value.is_a?(IntegerPrimitive)
            result = IntegerPrimitive.new(result.to_i, left_value.start_index, right_value.end_index)
          else
            result = FloatPrimitive.new(result.to_f, left_value.start_index, right_value.end_index)
          end

        result
    end

    def visit_exponentiation(node, runtime)
        left_value = node.left.traverse(self, runtime)
        right_value = node.right.traverse(self, runtime)

        unless is_number(left_value) && is_number(right_value)
            raise "Exponentiation operands must be Numbers"
        end

        result = left_value.value ** right_value.value
        if left_value.is_a?(IntegerPrimitive) && right_value.is_a?(IntegerPrimitive)
            result = IntegerPrimitive.new(result.to_i, left_value.start_index, right_value.end_index)
          else
            result = FloatPrimitive.new(result.to_f, left_value.start_index, right_value.end_index) 
        end

        result
    end

    def visit_negation(node, runtime)
        node_value = node.node.traverse(self, runtime)

        unless node_value.is_a?(IntegerPrimitive)
            raise "Negation operand must be an IntegerPrimitive"
        end

        result = -(node_value.value)
        if node_value.is_a?(IntegerPrimitive)
            result = result = IntegerPrimitive.new(result.to_i, node_value.start_index, node_value.end_index) 
        else
            result = FloatPrimitive.new(result.to_f, node_value.start_index, node_value.end_index)
        end
        result
    end

    ''' Logical Operations'''
    def visit_logical_and(node, runtime)
        left_value = node.left.traverse(self, runtime)
        right_value = node.right.traverse(self, runtime)

        unless left_value.is_a?(BooleanPrimitive) and right_value.is_a?(BooleanPrimitive)
            raise "And operands must be BooleanPrimitives"
        end

        BooleanPrimitive.new(left_value.value && right_value.value, left_value.start_index, right_value.end_index)
    end

    def visit_logical_or(node, runtime)
        left_value = node.left.traverse(self, runtime)
        right_value = node.right.traverse(self, runtime)

        unless left_value.is_a?(BooleanPrimitive) and right_value.is_a?(BooleanPrimitive)
            raise "Or operands must be BooleanPrimitives"
        end

        BooleanPrimitive.new(left_value.value || right_value.value, left_value.start_index, right_value.end_index)
    end

    def visit_logical_not(node, runtime)
        operand_value = node.operand.traverse(self, runtime)

        unless operand_value.is_a?(BooleanPrimitive)
            raise "Not operand must be a Boolean Primitive"
        end

        BooleanPrimitive.new(!operand_value.value, operand_value.start_index, operand_value.end_index)
    end

    ''' Bitwise Operations'''
    def visit_bitwise_and(node, runtime)
        left_value = node.left.traverse(self, runtime)
        right_value = node.right.traverse(self, runtime)

        unless left_value.is_a?(IntegerPrimitive) and right_value.is_a?(IntegerPrimitive)
            raise "And operands must be Integer Primitives"
        end

        IntegerPrimitive.new(left_value.value & right_value.value, left_value.start_index, right_value.end_index)
    end

    def visit_bitwise_or(node, runtime)
        left_value = node.left.traverse(self, runtime)
        right_value = node.right.traverse(self, runtime)

        unless left_value.is_a?(IntegerPrimitive) and right_value.is_a?(IntegerPrimitive)
            raise "Or operands must be Integer Primitives"
        end

        IntegerPrimitive.new(left_value.value | right_value.value, left_value.start_index, right_value.end_index)
    end

    def visit_bitwise_xor(node, runtime)
        left_value = node.left.traverse(self, runtime)
        right_value = node.right.traverse(self, runtime)

        unless left_value.is_a?(IntegerPrimitive) and right_value.is_a?(IntegerPrimitive)
            raise "Xor operands must be Integer Primitives"
        end

        IntegerPrimitive.new(left_value.value ^ right_value.value, left_value.start_index, right_value.end_index)
    end

    def visit_bitwise_not(node, runtime)
        operand_value = node.operand.traverse(self, runtime)

        unless operand_value.is_a?(IntegerPrimitive)
            raise "Not operand must be a Integer Primitive"
        end

        IntegerPrimitive.new(~(operand_value.value), operand_value.start_index, operand_value.end_index)
    end

    def visit_left_shift(node, runtime)
        operand_value = node.operand.traverse(self, runtime)
        amount_value = node.amount.traverse(self, runtime)

        unless operand_value.is_a?(IntegerPrimitive) and amount_value.is_a?(IntegerPrimitive)
            raise "Left Shift Operand and Amount must be Integer Primitives"
        end

        IntegerPrimitive.new(operand_value.value << amount_value.value, operand_value.start_index, amount_value.end_index)
    end

    def visit_right_shift(node, runtime)
        operand_value = node.operand.traverse(self, runtime)
        amount_value = node.amount.traverse(self, runtime)

        unless operand_value.is_a?(IntegerPrimitive) and amount_value.is_a?(IntegerPrimitive)
            raise "Right Shift Operand and Amount must be Integer Primitives"
        end

        IntegerPrimitive.new(operand_value.value >> amount_value.value, operand_value.start_index, amount_value.end_index)
    end


    ''' Relational Operations'''
    def visit_equals(node, runtime)
        left_value = node.left.traverse(self, runtime)
        right_value = node.right.traverse(self, runtime)

        BooleanPrimitive.new(left_value.value == right_value.value, left_value.start_index, right_value.end_index)
    end

    def visit_not_equals(node, runtime)
        left_value = node.left.traverse(self, runtime)
        right_value = node.right.traverse(self, runtime)

        BooleanPrimitive.new(left_value.value != right_value.value, left_value.start_index, right_value.end_index)
    end

    def visit_less_than(node, runtime)
        left_value = node.left.traverse(self, runtime)
        right_value = node.right.traverse(self, runtime)

        unless is_number(left_value) && is_number(right_value)
            raise "Operands must be Numbers"
        end

        BooleanPrimitive.new(left_value.value < right_value.value, left_value.start_index, right_value.end_index)
    end

    def visit_less_than_equal_to(node, runtime)
        left_value = node.left.traverse(self, runtime)
        right_value = node.right.traverse(self, runtime)

        unless is_number(left_value) && is_number(right_value)
            raise "Operands must be Numbers"
        end

        BooleanPrimitive.new(left_value.value <= right_value.value, left_value.start_index, right_value.end_index)
    end

    def visit_greater_than(node, runtime)
        left_value = node.left.traverse(self, runtime)
        right_value = node.right.traverse(self, runtime)

        unless is_number(left_value) && is_number(right_value)
            raise "Operands must be Numbers"
        end

        BooleanPrimitive.new(left_value.value > right_value.value, left_value.start_index, right_value.end_index)
    end

    def visit_greater_than_equal_to(node, runtime)
        left_value = node.left.traverse(self, runtime)
        right_value = node.right.traverse(self, runtime)

        unless is_number(left_value) && is_number(right_value)
            raise "Operands must be Numbers"
        end

        BooleanPrimitive.new(left_value.value >= right_value.value, left_value.start_index, right_value.end_index)
    end

    ''' Casting Operators'''
    def visit_float_to_int(node, runtime)
        node_value = node.value.traverse(self, runtime)

        unless node_value.is_a?(FloatPrimitive)
            raise "Casting operand must be an FloatPrimitive"
        end

        integer_primitive = IntegerPrimitive.new(node_value.to_i, node_value.start_index, node_value.end_index)
    end

    def visit_int_to_float(node, runtime)
        node_value = node.value.traverse(self, runtime)

        unless node_value.is_a?(IntegerPrimitive)
            raise "Casting operand must be an IntegerPrimitive"
        end

        float_primitive = FloatPrimitive.new(node_value.to_f, node_value.start_index, node_value.end_index)
    end

    ''' Statistical Functions'''
    def visit_max(max_node, runtime)
        left_value = max_node.left.traverse(self, runtime)
        right_value = max_node.right.traverse(self, runtime)
        
        unless left_value.is_a?(CellAddressPrimitive) and right_value.is_a?(CellAddressPrimitive)
            raise "Statistical functions accept two CellLvalues"
        end

        top_left_row, top_left_col = left_value.row, left_value.column
        bottom_right_row, bottom_right_col = right_value.row, right_value.column
        
        max_value = nil
        (top_left_row..bottom_right_row).each do |row|
          (top_left_col..bottom_right_col).each do |col|
            address = ([row, col])
            cell_value = runtime.get_cell_value(address)
            max_value = cell_value.value if max_value.nil? || cell_value.value > max_value
          end
        end
        
        #max_value
        if max_value.is_a?(Integer)
            return IntegerPrimitive.new(max_value, nil, nil)
        end
        return FloatPrimitive.new(max_value, nil, nil)
    end
      
    def visit_min(min_node, runtime)
        left_value = min_node.left.traverse(self, runtime)
        right_value = min_node.right.traverse(self, runtime)
        
        unless left_value.is_a?(CellAddressPrimitive) and right_value.is_a?(CellAddressPrimitive)
            raise "Statistical functions accept two CellLvalues"
        end
        
        top_left_row, top_left_col = left_value.row, left_value.column
        bottom_right_row, bottom_right_col = right_value.row, right_value.column
        
        min_value = nil
        (top_left_row..bottom_right_row).each do |row|
          (top_left_col..bottom_right_col).each do |col|
            address = ([row, col])
            cell_value = runtime.get_cell_value(address)
            min_value = cell_value.value if min_value.nil? || cell_value.value < min_value
          end
        end
        
        #min_value
        if min_value.is_a?(Integer)
            return IntegerPrimitive.new(min_value, nil, nil)
        end
        return FloatPrimitive.new(min_value, nil, nil)
    end
      
    def visit_mean(mean_node, runtime)
        left_value = mean_node.left.traverse(self, runtime)
        right_value = mean_node.right.traverse(self, runtime)
        
        unless left_value.is_a?(CellAddressPrimitive) and right_value.is_a?(CellAddressPrimitive)
            raise "Statistical functions accept two CellLvalues"
        end
        
        top_left_row, top_left_col = left_value.row, left_value.column
        bottom_right_row, bottom_right_col = right_value.row, right_value.column
        
        sum = 0
        count = 0
        (top_left_row..bottom_right_row).each do |row|
          (top_left_col..bottom_right_col).each do |col|
            address = ([row, col])
            cell_value = runtime.get_cell_value(address)
            sum += cell_value.value if !(cell_value.nil?)
            count +=1 if !(cell_value.nil?)
          end
        end
        
        mean = sum/count.to_f
        if mean.is_a?(Integer)
            return IntegerPrimitive.new(mean, nil, nil)
        end
        return FloatPrimitive.new(mean, nil, nil)
    end
      
    def visit_sum(sum_node, runtime)
        left_value = sum_node.left.traverse(self, runtime)
        right_value = sum_node.right.traverse(self, runtime)
        
        unless left_value.is_a?(CellAddressPrimitive) and right_value.is_a?(CellAddressPrimitive)
            raise "Statistical functions accept two CellLvalues"
        end
        
        top_left_row, top_left_col = left_value.row, left_value.column
        bottom_right_row, bottom_right_col = right_value.row, right_value.column
        
        sum = 0
        (top_left_row..bottom_right_row).each do |row|
          (top_left_col..bottom_right_col).each do |col|
            address = ([row, col])
            cell_value = runtime.get_cell_value(address)
            sum += cell_value.value if !(cell_value.nil?)
          end
        end
        
        #sum
        if sum.is_a?(Integer)
            return IntegerPrimitive.new(sum, nil, nil)
        end
        return FloatPrimitive.new(sum, nil, nil)
    end
end