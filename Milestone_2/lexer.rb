class Token
    attr_reader :type, :text, :start_index, :end_index

    def initialize(type, text, start_index, end_index)
        @type = type
        @text = text
        @start_index = start_index
        @end_index = end_index
    end
end

class Lexer
    def initialize(source)
        @source = source
        @i  = 0
        @tokens = []
        @token_so_far = ''
    end

    # functions: lex, has_letter, has(character), capture, abandon, emit_token

    def has(c)
        @i < @source.length && @source[@i] == c
    end

    def has_letter
        @i < @source.length && 'a' <= @source[@i] && @source[@i] <= 'z'
    end

    def has_number
        @i < @source.length && '0' <= @source[@i] && @source[@i] <= '9'
    end

    def capture
        @token_so_far += @source[@i]
        @i += 1
    end

    def abandon
        @token_so_far = ''
        @i += 1
    end

    def emit_token(type)
        @tokens.push(Token.new(type, @token_so_far, @i - @token_so_far.length, @i - 1))
        #p @tokens
        # resetting token, 'pristine environment'
        @token_so_far = ''
    end

    def lex
        while @i < @source.length

            if has('{')
                capture
                emit_token(:left_curly)
            elsif has('}')
                capture
                emit_token(:right_curly)
            elsif has('[')
                capture
                emit_token(:left_bracket)
            elsif has(']')
                capture
                emit_token(:right_bracket)
            elsif has(',')
                capture
                emit_token(:comma)
            elsif has('#')
                capture
                emit_token(:hash)
            elsif has('(')
                    capture
                    emit_token(:left_parentheses)
            elsif has(')')
                    capture
                    emit_token(:right_parentheses)
            elsif has('=')
                capture
                    if has('=')
                        capture
                        emit_token(:logical_equals)
                    else
                    emit_token(:equals)
                    end
            elsif has('-')
                capture
                if @tokens.empty? || @tokens.last.type == :left_parentheses
                  emit_token(:negation)
                else
                  emit_token(:subtract)
                end
            elsif has("\n")
                        capture
                        emit_token(:linebreak)

            elsif has_number
                while has_number || @source[@i] == '.'
                    capture
                end
                if @token_so_far.include?('.')
                    emit_token(:float_literal)
                  else
                    emit_token(:integer_literal)
                  end

            elsif has('+')
                capture
                emit_token(:add)
            elsif has('/')
                capture
                emit_token(:divide)
            elsif has('%')
                capture
                emit_token(:modulo)
            elsif has('~')
                capture
                emit_token(:bitwise_not)
            elsif has('^')
                capture
                emit_token(:xor)

            elsif has('*')
                capture
                if has('*')
                    capture
                    emit_token(:exponentiation)
                else
                    emit_token(:multiply)
                end

            elsif has('<')
                capture
                if has('=')
                    capture
                    emit_token(:less_than_equal_to)
                elsif has('<')
                    capture
                    emit_token(:left_shift)
                else
                    emit_token(:less_than)
                end

            elsif has('>')
                capture
                if has('=')
                    capture
                    emit_token(:greater_than_equal_to)
                elsif has('>')
                    capture
                    emit_token(:right_shift)
                else
                    emit_token(:greater_than)
                end

            elsif has('!')
                capture
                if has('=')
                    capture
                    emit_token(:not_equal)
                else
                    emit_token(:logical_not)
                end

            elsif has('&')
                capture
                if has('&')
                    capture
                    emit_token(:logical_and)
                else
                    emit_token(:bitwise_and)
                end

            elsif has('|')
                capture
                if has('|')
                    capture
                    emit_token(:logical_or)
                else
                    emit_token(:bitwise_or)
                end

            elsif has_letter
                while has_letter
                    capture
                end

                if @token_so_far == 'and'
                    emit_token(:and)
                elsif @token_so_far == 'or'
                    emit_token(:or)
                elsif @token_so_far == 'xor'
                    emit_token(:xor)
                elsif @token_so_far == 'max'
                    emit_token(:max)
                elsif @token_so_far == 'min'
                    emit_token(:min)
                elsif @token_so_far == 'mean'
                    emit_token(:mean)
                elsif @token_so_far == 'sum'
                    emit_token(:sum)
                elsif @token_so_far == 'float'
                    emit_token(:float)
                elsif @token_so_far == 'int'
                    emit_token(:int)
                elsif @token_so_far == 'true' or @token_so_far == 'false'
                    emit_token(:boolean)
                else
                    emit_token(:identifier)
                end

            elsif has(' ') || has("\r")
                abandon
            end
        end 
        @tokens
    end
end

