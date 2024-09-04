require_relative 'ast.rb'
require_relative 'grid.rb'
require_relative 'runtime.rb'

# Integer Primitives
negative_three = IntegerPrimitive.new(-3)
zero = IntegerPrimitive.new(0)
one = IntegerPrimitive.new(1)
two = IntegerPrimitive.new(2)
three = IntegerPrimitive.new(3, nil, nil)
four = IntegerPrimitive.new(4)
five = IntegerPrimitive.new(5)
seven = IntegerPrimitive.new(7)
eight = IntegerPrimitive.new(8)
ten = IntegerPrimitive.new(10)
twelve = IntegerPrimitive.new(12)

binary_num1 = IntegerPrimitive.new(0b1010)
binary_num2 = IntegerPrimitive.new(0b1100)

# Float Primitives
one_half = FloatPrimitive.new(1.5)
three_three_quarters = FloatPrimitive.new(3.75)
three_point_three = FloatPrimitive.new(3.3)
three_point_two = FloatPrimitive.new(3.2)

# Boolean Primitives
bool_true = BooleanPrimitive.new(true)
bool_false = BooleanPrimitive.new(false)

grid = Grid.new

# Addition
addition = Add.new(one, two)
addition_float = Add.new(one_half, three_three_quarters)
add_float_text = addition_float.traverse(Serializer.new, nil)
puts "Addition Float:"
puts add_float_text
add_float_result = addition_float.traverse(Evaluator.new, Runtime.new(grid))
puts add_float_result.value

# Subtraction
puts "Subtraction:"
subtraction = Subtract.new(two, three)
sub_text = subtraction.traverse(Serializer.new, nil)
puts sub_text
sub_result = subtraction.traverse(Evaluator.new, Runtime.new(grid))
puts sub_result.value

# Multiplication
product = Multiply.new(two, three)

# Division
puts "Division:"
division = Divide.new(three, two)
divide_text = division.traverse(Serializer.new, nil)
puts divide_text
divide_result = division.traverse(Evaluator.new, Runtime.new(grid))
puts divide_result.value

# Modulo
puts "Modulo:"
modulo = Modulo.new(three, ten)
modulo_text = modulo.traverse(Serializer.new, nil)
puts modulo_text
modulo_result = modulo.traverse(Evaluator.new, Runtime.new(grid))
puts modulo_result.value

# Exponentiation
puts "Exponentiation:"
exponentiation = Exponentiation.new(three, ten)
exponentiation_text = exponentiation.traverse(Serializer.new, nil)
puts exponentiation_text
exponentiation_result = exponentiation.traverse(Evaluator.new, Runtime.new(grid))
puts exponentiation_result.value

# Negation
puts "Negation:"
negation = Negation.new(three)
negation_text = negation.traverse(Serializer.new, nil)
puts negation_text
negation_result = negation.traverse(Evaluator.new, nil)
puts negation_result.value

# And
puts "And:"
and_operation = Logical_And.new(bool_true, bool_false)
and_text = and_operation.traverse(Serializer.new, nil)
and_result = and_operation.traverse(Evaluator.new, Runtime.new(grid))
puts and_text
puts and_result.value

# Or:
puts "Or:"
or_operation = Logical_Or.new(bool_true, bool_false)
or_text = or_operation.traverse(Serializer.new, nil)
or_result = or_operation.traverse(Evaluator.new, Runtime.new(grid))
puts or_text
puts or_result.value

# Not
puts "Not:"
not_operation = Logical_Not.new(Greater_Than.new(two, eight))
not_text = not_operation.traverse(Serializer.new, nil)
not_result = not_operation.traverse(Evaluator.new, Runtime.new(grid))
puts not_text
puts not_result.value

# Bitwise And
puts "Bitwise And:"
bitwise_and_operation = Bitwise_And.new(binary_num1, binary_num2)
bitwise_and_text = bitwise_and_operation.traverse(Serializer.new, nil)
bitwise_and_result = bitwise_and_operation.traverse(Evaluator.new, Runtime.new(grid))
puts bitwise_and_text
puts bitwise_and_result.value

# Bitwise Or:
puts "Bitwise Or:"
bitwise_or_operation = Bitwise_Or.new(binary_num1, binary_num2)
bitwise_or_text = bitwise_or_operation.traverse(Serializer.new, nil)
bitwise_or_result = bitwise_or_operation.traverse(Evaluator.new, Runtime.new(grid))
puts bitwise_or_text
puts bitwise_or_result.value

# Bitwise Xor:
puts "Bitwise Xor:"
bitwise_xor_operation = Bitwise_Xor.new(binary_num1, binary_num2)
bitwise_xor_text = bitwise_xor_operation.traverse(Serializer.new, nil)
bitwise_xor_result = bitwise_xor_operation.traverse(Evaluator.new, Runtime.new(grid))
puts bitwise_xor_text
puts bitwise_xor_result.value

# Bitwise Not
puts "Bitwise Not:"
bitwise_not_operation = Bitwise_Not.new(binary_num1)
bitwise_not_text = bitwise_not_operation.traverse(Serializer.new, nil)
bitwise_not_result = bitwise_not_operation.traverse(Evaluator.new, Runtime.new(grid))
puts bitwise_not_text
puts bitwise_not_result.value

# Left Shift
puts "Left Shift:"
left_shift_operation = Left_Shift.new(binary_num1, three)
left_shift_text = left_shift_operation.traverse(Serializer.new, nil)
left_shift_result = left_shift_operation.traverse(Evaluator.new, Runtime.new(grid))
puts left_shift_text
puts left_shift_result.value


# Right Shift
puts "Right Shift:"
right_shift_operation = Right_Shift.new(binary_num1, three)
right_shift_text = right_shift_operation.traverse(Serializer.new, nil)
right_shift_result = right_shift_operation.traverse(Evaluator.new, Runtime.new(grid))
puts right_shift_text
puts right_shift_result.value

# Equals
puts "Equals:"
equals_operation = Equals.new(zero, zero)
equals_text = equals_operation.traverse(Serializer.new, nil)
equals_result = equals_operation.traverse(Evaluator.new, Runtime.new(grid))
puts equals_text
puts equals_result.value

# Not Equals
puts "Not Equals:"
not_equals_operation = Not_Equals.new(zero, one)
not_equals_text = not_equals_operation.traverse(Serializer.new, nil)
not_equals_result = not_equals_operation.traverse(Evaluator.new, Runtime.new(grid))
puts not_equals_text
puts not_equals_result.value

# Not Equals Cell
puts "Not Equals Cell:"
grid_cell = Grid.new
grid_cell.set_cell([0, 0], bool_false)
grid_cell.set_cell([0, 1], bool_true)
ast_cell = Not_Equals.new(CellRvalue.new(zero, zero), CellRvalue.new(zero, one))
grid_cell.set_cell([1, 1], ast_cell)
model_primitive_cell = grid_cell.get_cell([1, 1])
puts ast_cell.traverse(Serializer.new, nil)
puts model_primitive_cell.value

# Less Than
puts "Less Than:"
less_than_operation = Less_Than.new(one, zero)
less_than_text = less_than_operation.traverse(Serializer.new, nil)
less_than_result = less_than_operation.traverse(Evaluator.new, Runtime.new(grid))
puts less_than_text
puts less_than_result.value

# Less Than Equal To
puts "Less Than or Equal To:"
less_than_equal_to_operation = Less_Than_Equal_to.new(zero, one)
less_than_equal_to_text = less_than_equal_to_operation.traverse(Serializer.new, nil)
less_than_equal_to_result = less_than_equal_to_operation.traverse(Evaluator.new, Runtime.new(grid))
puts less_than_equal_to_text
puts less_than_equal_to_result.value

# Float to Int
puts "Float to Int:"
casting1_operation = FloatToInt.new(one_half)
casting1_text = casting1_operation.traverse(Serializer.new, nil)
casting1_result = casting1_operation.traverse(Evaluator.new, Runtime.new(grid))
puts casting1_text
puts casting1_result.value

# Int to Float
puts "Int to Float:"
casting2_operation = IntToFloat.new(three, nil, nil)
casting2_text = casting2_operation.traverse(Serializer.new, nil)
casting2_result = casting2_operation.traverse(Evaluator.new, Runtime.new(grid))
puts casting2_text
puts casting2_result.value

# Arithmetic: (7 * 4 + 3) % 12
puts "Example One:"
expression_one = Modulo.new(Add.new(Multiply.new(seven, four), three), twelve)
expression_one_text = expression_one.traverse(Serializer.new, nil)
expression_one_result = expression_one.traverse(Evaluator.new, Runtime.new(grid))
puts expression_one_text
puts expression_one_result.value

# Rvalue lookup and shift: #[1 + 1, 4] << 3
puts "Example Two:"
grid_two = Grid.new
grid_two.set_cell([2, 4], eight)
ast_two = Left_Shift.new(CellRvalue.new(Add.new(one, one), four), three)
grid_two.set_cell([0, 0], ast_two)
model_primitive_two = grid_two.get_cell([0, 0])
puts ast_two.traverse(Serializer.new, nil)
puts model_primitive_two.value

# Test: #[0, 0] + 3
puts "Test:"
grid_test = Grid.new
grid_test.set_cell([0, 0], eight)
ast_test = Add.new(CellRvalue.new(zero, zero), three)
grid_test.set_cell([0, 1], ast_test)
model_primitive_test = grid_test.get_cell([0, 1])
puts ast_test.traverse(Serializer.new, nil)
puts model_primitive_test.value

# Rvalue lookup and comparison: #[0, 0] < #[0, 1]
puts "Example Three:"
grid_three = Grid.new
grid_three.set_cell([0, 0], one)
grid_three.set_cell([0, 1], eight)
ast_three = Less_Than.new(CellRvalue.new(zero, zero), CellRvalue.new(zero, one))
grid_three.set_cell([1, 1], ast_three)
model_primitive_three = grid_three.get_cell([1, 1])
puts ast_three.traverse(Serializer.new, nil)
puts model_primitive_three.value

# Logic and comparison: !(3.3 > 3.2)
puts "Example Four:"
expression_four = Logical_Not.new(Greater_Than.new(three_point_three, three_point_two))
expression_four_text = expression_four.traverse(Serializer.new, nil)
expression_four_result = expression_four.traverse(Evaluator.new, Runtime.new(grid))
puts expression_four_text
puts expression_four_result.value

#Sum: sum([1, 2], [5, 3])
puts "Example Five:"
grid_five = Grid.new
grid_five.set_cell([1, 2], one)
grid_five.set_cell([2, 2], two)
grid_five.set_cell([3, 3], three)
grid_five.set_cell([5, 3], four)
ast_five = Sum.new(CellLvalue.new(one, two), CellLvalue.new(five, three))
grid_five.set_cell([6, 6], ast_five)
model_primitive_five = grid_five.get_cell([6, 6])
puts ast_five.traverse(Serializer.new, nil)
puts model_primitive_five

# Casting: float(7) / 2
puts "Example Six:"
expression_six = Divide.new(IntToFloat.new(seven), two)
expression_six_text = expression_six.traverse(Serializer.new, nil)
expression_six_result = expression_six.traverse(Evaluator.new, Runtime.new(grid))
puts expression_six_text
puts expression_six_result.value

# Bad Example
puts "Bad Example:"
grid_bad = Grid.new
grid_bad.set_cell([0, 0], bool_false)
grid_bad.set_cell([0, 1], bool_true)
ast_bad = Less_Than.new(CellRvalue.new(zero, zero), CellRvalue.new(zero, one))
grid_bad.set_cell([1, 1], ast_bad)
model_primitive_bad = grid_bad.get_cell([1, 1])
puts ast_bad.traverse(Serializer.new, nil)
puts model_primitive_.value