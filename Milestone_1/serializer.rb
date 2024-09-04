require_relative 'ast.rb'

class Serializer
    ''' Primitives '''
    def visit_integer(node)
        node.value.to_s
    end

    def visit_float(node)
        node.value.to_s
    end

    def visit_boolean(node)
        node.value.to_s
    end

    def visit_string(node)
        node.value.to_s
    end

    def visit_cell_address(node, runtime)
        row_str = node.row.traverse(self, nil)
        col_str = node.column.traverse(self, nil)
        "[#{row_str},#{col_str}]"
    end

    ''' Arithmetic Operations'''
    def visit_add(add_node, runtime)
        left_str = add_node.left.traverse(self, nil)
        right_str = add_node.right.traverse(self, nil)
        "(#{left_str} + #{right_str})"
    end

    def visit_subtract(subtract_node, runtime)
        left_str = subtract_node.left.traverse(self, nil)
        right_str = subtract_node.right.traverse(self, nil)
        "(#{left_str} - #{right_str})"
    end

    def visit_multiply(multiply_node, runtime)
        left_str = multiply_node.left.traverse(self, nil)
        right_str = multiply_node.right.traverse(self, nil)
        "(#{left_str} * #{right_str})"
    end

    def visit_divide(divide_node, runtime)
        left_str = divide_node.left.traverse(self, nil)
        right_str = divide_node.right.traverse(self, nil)
        "(#{left_str} / #{right_str})"
    end

    def visit_modulo(modulo_node, runtime)
        left_str = modulo_node.left.traverse(self, nil)
        right_str = modulo_node.right.traverse(self, nil)
        "(#{left_str} % #{right_str})"
    end

    def visit_exponentiation(exponentiation_node, runtime)
        left_str = exponentiation_node.left.traverse(self, nil)
        right_str = exponentiation_node.right.traverse(self, nil)
        "(#{left_str} ** #{right_str})"
    end

    def visit_negation(neg_node, runtime)
        str = neg_node.node.traverse(self, nil)
        "(-#{str})"
    end

    ''' Logical Operations'''
    def visit_logical_and(and_node, runtime)
        left_str = and_node.left.traverse(self, nil)
        right_str = and_node.right.traverse(self, nil)
        "(#{left_str} && #{right_str})"
    end

    def visit_logical_or(or_node, runtime)
        left_str = or_node.left.traverse(self, nil)
        right_str = or_node.right.traverse(self, nil)
        "(#{left_str} || #{right_str})"
    end

    def visit_logical_not(not_node, runtime)
        operand_str = not_node.operand.traverse(self, nil)
        "!#{operand_str}"
    end

    ''' Bitwise Operations'''
    def visit_bitwise_and(and_node, runtime)
        left_str = and_node.left.traverse(self, nil)
        right_str = and_node.right.traverse(self, nil)
        "(#{left_str} & #{right_str})"
    end

    def visit_bitwise_or(or_node, runtime)
        left_str = or_node.left.traverse(self, nil)
        right_str = or_node.right.traverse(self, nil)
        "(#{left_str} | #{right_str})"
    end

    def visit_bitwise_xor(xor_node, runtime)
        left_str = xor_node.left.traverse(self, nil)
        right_str = xor_node.right.traverse(self, nil)
        "(#{left_str} ^ #{right_str})"
    end

    def visit_bitwise_not(not_node, runtime)
        operand_str = not_node.operand.traverse(self, nil)
        "~#{operand_str}"
    end

    def visit_left_shift(node, runtime)
        operand_str = node.operand.traverse(self, nil)
        amount_str = node.amount.traverse(self, nil)
        "#{operand_str} << #{amount_str}"
    end

    def visit_right_shift(node, runtime)
        operand_str = node.operand.traverse(self, nil)
        amount_str = node.amount.traverse(self, nil)
        "#{operand_str} >> #{amount_str}"
    end

    ''' Relational Operations'''
    def visit_equals(node, runtime)
        left_str = node.left.traverse(self, nil)
        right_str = node.right.traverse(self, nil)
        "(#{left_str} = #{right_str})"
    end

    def visit_not_equals(node, runtime)
        left_str = node.left.traverse(self, nil)
        right_str = node.right.traverse(self, nil)
        "(#{left_str} != #{right_str})"
    end

    def visit_less_than(node, runtime)
        left_str = node.left.traverse(self, nil)
        right_str = node.right.traverse(self, nil)
        "(#{left_str} < #{right_str})"
    end

    def visit_less_than_equal_to(node, runtime)
        left_str = node.left.traverse(self, nil)
        right_str = node.right.traverse(self, nil)
        "(#{left_str} <= #{right_str})"
    end

    def visit_greater_than(node, runtime)
        left_str = node.left.traverse(self, nil)
        right_str = node.right.traverse(self, nil)
        "(#{left_str} > #{right_str})"
    end

    def visit_greater_than_equal_to(node, runtime)
        left_str = node.left.traverse(self, nil)
        right_str = node.right.traverse(self, nil)
        "(#{left_str} >= #{right_str})"
    end

    ''' Casting Operators'''
    def visit_float_to_int(node, runtime)
        node_str = node.value.traverse(self, nil)
        "int(#{node_str})"
    end

    def visit_int_to_float(node, runtime)
        node_str = node.value.traverse(self, nil)
        "float(#{node_str})"
    end

    ''' Statistical Functions'''
    def visit_max(max_node, runtime)
        left_str = max_node.left.traverse(self, nil)
        right_str = max_node.right.traverse(self, nil)
        "max(#{left_str}, #{right_str})"
    end
      
    def visit_min(min_node, runtime)
        left_str = min_node.left.traverse(self, nil)
        right_str = min_node.right.traverse(self, nil)
        "min(#{left_str}, #{right_str})"
    end
      
    def visit_mean(mean_node, runtime)
        left_str = mean_node.left.traverse(self, nil)
        right_str = mean_node.right.traverse(self, nil)
        "mean(#{left_str}, #{right_str})"
    end
      
    def visit_sum(sum_node, runtime)
        left_str = sum_node.left.traverse(self, nil)
        right_str = sum_node.right.traverse(self, nil)
        "sum(#{left_str}, #{right_str})"
    end

    ''' Cell Values'''
    def visit_lvalue(node, runtime)
        addr_row_str = node.address_row.traverse(self, nil)
        addr_col_str = node.address_col.traverse(self, nil)
        "[#{addr_row_str}, #{addr_col_str}]"
    end
      
    def visit_rvalue(node, runtime)
        addr_row_str = node.address_row.traverse(self, nil)
        addr_col_str = node.address_col.traverse(self, nil)
        "#[#{addr_row_str}, #{addr_col_str}]"
    end
    
  end