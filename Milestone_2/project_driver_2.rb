require_relative 'lexer.rb'
require_relative 'parser.rb'
require_relative '../Milestone_1/evaluator.rb'
require_relative '../Milestone_1/ast.rb'
require_relative '../Milestone_1/grid.rb'
require_relative '../Milestone_1/runtime.rb'
require_relative '../Milestone_1/serializer.rb'

grid = Grid.new
runtime = Runtime.new(grid)

grid_two = Grid.new
grid_two.set_cell([0, 0], IntegerPrimitive.new(1, nil, nil))
zero = IntegerPrimitive.new(0, nil, nil)
ast_two = Add.new(CellRvalue.new(zero, zero, nil, nil), IntegerPrimitive.new(3, nil, nil), nil, nil)
grid_two.set_cell([1, 1], ast_two)
model_primitive_two = grid_two.get_cell([1, 1])

grid_three = Grid.new
grid_three.set_cell([0, 0], IntegerPrimitive.new(1, nil, nil))
grid_three.set_cell([1, 1], IntegerPrimitive.new(2, nil, nil))
zero = IntegerPrimitive.new(0, nil, nil)
one = IntegerPrimitive.new(1, nil, nil)
ast_three = Less_Than.new(CellRvalue.new(Subtract.new(one, one, nil, nil), zero, nil, nil), CellRvalue.new(Multiply.new(one, one, nil, nil), one, nil, nil), nil, nil)
grid_three.set_cell([2, 2], ast_three)
model_primitive_three = grid_three.get_cell([2, 2])

grid_five = Grid.new
two = IntegerPrimitive.new(2, nil, nil)
ten = IntegerPrimitive.new(10, nil, nil)
grid_five.set_cell([0, 0], ten)
grid_five.set_cell([2, 1], two)
ast_five = Add.new(one, Sum.new(CellLvalue.new(zero, zero, nil, nil), CellLvalue.new(two, one, nil, nil), nil, nil), nil, nil)
grid_five.set_cell([6, 6], ast_five)
model_primitive_five = grid_five.get_cell([6, 6])

# ten = IntegerPrimitive.new(10, nil, nil)
# casting_operation = IntToFloat.new(ten, nil, nil)
# casting_result = casting_operation.traverse(Evaluator.new, Runtime.new(grid))
# puts casting_result.value

example1 = "(5 + 2) * 3 % 4"
example2 = "#[0, 0] + 3"
example3 = "#[1 - 1, 0] < #[1 * 1, 1]"
example4 = "(5 > 3) && !(2 > 8)"
example5 = "1 + sum([0, 0], [2, 1])"
example6 = "float(10) / 4.0"

bad_example1 = "7 + * 14"
bad_example2 = "min([0, 0] [1, 2])"
bad_example3 = "#[0 0]"

lexer = Lexer.new(example6)
tokens = lexer.lex
puts "Lexer"
tokens.each do |token|
    puts "#{token.type}, \"#{token.text}\", #{token.start_index}, #{token.end_index}"
end
puts "\n"

puts "Parser"
parser = Parser.new(tokens)
ast = parser.parse
p ast
puts "\n"

puts "Evaluator"
eval =  ast.traverse(Evaluator.new, Runtime.new(grid))
p eval.value