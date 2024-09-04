class Parser
    def initialize(tokens)
        @tokens = tokens
        @i = 0
    end

    def has(type)
        @i < @tokens.size && @tokens[@i].type == type
    end

    # Similar to capture()
    def advance
        @i += 1
        @tokens[@i - 1]
    end

    def parse 
        expression
    end

    def expression
        logical_expression
    end

    def logical_expression
        left = bitwise_shift_expression
        while has(:logical_and) || has(:logical_or)
            if has(:logical_and)
                advance
                right = bitwise_shift_expression
                left = Logical_And.new(left, right, left.start_index, right.end_index)
            elsif has(:logical_or)
                advance
                right = bitwise_shift_expression
                left = Logical_Or.new(left, right, left.start_index, right.end_index)
            end
        end
        return left
    end

    def bitwise_shift_expression
        left = bitwise_expression
        while has(:left_shift) || has(:right_shift)
            if has(:left_shift)
                advance
                right = bitwise_expression
                left = Left_Shift.new(left, right, left.start_index, right.end_index)
            elsif has(:right_shift)
                advance
                right = bitwise_expression
                left = Right_Shift.new(left, right, left.start_index, right.end_index)
            end
        end
        return left
    end

    def bitwise_expression
        left = relational_expression
        while has(:bitwise_and) || has(:bitwise_or) || has(:xor)
            if has(:bitwise_and)
                advance
                right = relational_expression
                left = Bitwise_And.new(left, right, left.start_index, right.end_index)
            elsif has(:bitwise_or)
                advance
                right = relational_expression
                left = Bitwise_Or.new(left, right, left.start_index, right.end_index)
            elsif has(:xor)
                advance
                right = relational_expression
                left = Bitwise_Xor.new(left, right, left.start_index, right.end_index)
            end
        end
        return left
    end

    def relational_expression
        left = additive_expression
        while has(:less_than) || has(:less_than_equal_to) || has(:greater_than) || has(:greater_than_equal_to)
            if has(:less_than)
                advance
                right = additive_expression
                left = Less_Than.new(left, right, left.start_index, right.end_index)
            elsif has(:less_than_equal_to)
                advance
                right = additive_expression
                left = Less_Than_Equal_to.new(left, right, left.start_index, right.end_index)
            elsif has(:greater_than)
                advance
                right = additive_expression
                left = Greater_Than.new(left, right, left.start_index, right.end_index)
            elsif has(:greater_than_equal_to)
                advance
                right = additive_expression
                left = Greater_Than_Equal_To.new(left, right, left.start_index, right.end_index)
            end
        end
        return left
    end

    def additive_expression
        left = multiplicative_expression
        while has(:add) || has(:subtract)
            if has(:add)
                advance
                right = multiplicative_expression
                left = Add.new(left, right, left.start_index, right.end_index)
            elsif has(:subtract)
                advance
                right = multiplicative_expression
                left = Subtract.new(left, right, left.start_index, right.end_index)
            end
        end
        return left
    end


    def multiplicative_expression
        left = exponentiation
        while has(:multiply) || has(:divide) || has(:modulo)
            if has(:multiply)
                advance
                right = exponentiation
                left = Multiply.new(left, right, left.start_index, right.end_index)
            elsif has(:divide)
                advance
                right = exponentiation
                left = Divide.new(left, right, left.start_index, right.end_index)
            elsif has(:modulo)
                advance
                right = exponentiation
                left = Modulo.new(left, right, left.start_index, right.end_index)
            end
        end
        return left
    end

    def exponentiation
        right = primary_expression
        while has(:exponentiation)
            if has(:exponentiation)
                advance
                right = Exponentation.new(primary_expression, right, left.start_index, right.end_index)
            end
        end
        return right
    end
    
    def primary_expression
        if has(:integer_literal)
            token = advance
            IntegerPrimitive.new(token.text.to_i, token.start_index, token.end_index)
            
        elsif has(:float_literal)
            token = advance
            FloatPrimitive.new(token.text.to_f, token.start_index, token.end_index)

        elsif has(:string_literal)
            token = advance
            StringPrimitive.new(token.text.to_s, token.start_index, token.end_index)

        elsif has(:boolean_literal)
            token = advance
            BooleanPrimitive.new(token.text, token.start_index, token.end_index)

        elsif has(:left_parentheses)
            advance
            result = parse
            if has(:right_parentheses)
                advance
            else
                raise "Missing right parentheses at index #{@tokens[@i-1].start_index}"
            end
            return result

        elsif has(:left_bracket)
            start = advance
            left = parse
            if has(:comma)
                advance
            else
                raise "Missing comma at index #{@tokens[@i-1].start_index}"
            end
            right = parse
            end_tok = advance
            return CellAddressPrimitive.new(left, right, start.start_index, end_tok.end_index)

        elsif has(:hash)
            hash_token = advance
            if has(:left_bracket)
                advance
            end
            left = parse
            if has(:comma)
                advance
            else
                raise "Missing comma at index #{@tokens[@i-1].start_index}"
            end
            right = parse
            if has(:right_bracket)
                token = advance
            end
            return CellRvalue.new(left, right, hash_token.start_index, token.end_index)

        elsif has(:int)
            token = advance  
            start_index = token.start_index 
            if has(:left_parentheses)
                advance 
            end
            value = parse 
            if has(:right_parentheses)
                advance 
            end
            end_index = @tokens[@i - 1].end_index 
            return FloatToInt.new(value, start_index, end_index)

        elsif has(:float)
            token = advance  
            start_index = token.start_index 
            if has(:left_parentheses)
                advance 
            end
            value = parse
            if has(:right_parentheses)
                advance 
            end
            end_index = @tokens[@i - 1].end_index 
            return IntToFloat.new(value, start_index, end_index)

        elsif has(:bitwise_not)
            bitwise_not_token = advance
            value_start_index = bitwise_not_token.end_index
            value = parse
            return Bitwise_Not.new(value, value_start_index, value.end_index)

        elsif has(:logical_not)
            not_token = advance
            open_parentheses_token = advance
            value_start_index = open_parentheses_token.end_index
            value = parse
            close_parentheses_token = advance
            value_end_index = close_parentheses_token.end_index
            return Logical_Not.new(value, value_start_index, value_end_index)

        elsif has(:negation)
            negation_token = advance
            value_start_index = negation_token.end_index
            value = parse
            return Negation.new(value, value_start_index, value.end_index)

        elsif has(:mean)
            token = advance 
            start_index = token.start_index  
            if has(:left_parentheses)
            advance 
            end
            left = parse 
            if has(:comma)
                advance
            else
                raise "Missing comma at index #{@tokens[@i-1].start_index}"
            end
            right = parse  
            if has(:right_parentheses)
                advance 
            end
            end_index = @tokens[@i - 1].end_index  
            return Mean.new(left, right, start_index, end_index)

        elsif has(:max)
            token = advance  
            start_index = token.start_index  
            if has(:left_parentheses)
            advance 
            end
            left = parse 
            if has(:comma)
                advance 
            else
                raise "Missing comma at index #{@tokens[@i-1].start_index}"
            end
            right = parse 
            if has(:right_parentheses)
                advance 
            end
            end_index = @tokens[@i - 1].end_index 
            return Max.new(left, right, start_index, end_index)

        elsif has(:min)
            token = advance  
            start_index = token.start_index  
            if has(:left_parentheses)
            advance 
            end
            left = parse  
            if has(:comma)
                advance  
            else
                raise "Missing comma at index #{@tokens[@i-1].start_index}"
            end
            right = parse
            if has(:right_parentheses)
                advance 
            end
            end_index = @tokens[@i - 1].end_index  
            return Min.new(left, right, start_index, end_index)

        elsif has(:sum)
            token = advance 
            start_index = token.start_index
            if has(:left_parentheses)
            advance 
            end
            left = parse 
            if has(:comma)
                advance
            else
                raise "Missing comma at index #{@tokens[@i-1].start_index}"
            end
            right = parse  
            if has(:right_parentheses)
                advance  
            end
            end_index = @tokens[@i - 1].end_index 
            return Sum.new(left, right, start_index, end_index)
        
        else
            raise "Unexpected token #{@tokens[@i].type} at index [#{@tokens[@i].start_index}, #{@tokens[@i].end_index}]" 
        end
    end
end