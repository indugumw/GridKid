require_relative '../Milestone_2/lexer.rb'
require_relative '../Milestone_2/parser.rb'
require_relative '../Milestone_1/evaluator.rb'
require_relative '../Milestone_1/ast.rb'
require_relative '../Milestone_1/grid.rb'
require_relative '../Milestone_1/runtime.rb'
require_relative '../Milestone_1/serializer.rb'
require 'curses'
include Curses

# Helper function that prints the selected cell's value in the display panel
def print_selected_cell_value(display_panel, grid, selected_row, selected_col)
  display_panel.clear
  display_panel.box()

  display_panel.setpos(1, 1)
  display_panel.addstr("Display Panel")
  
  if grid.get_cell([selected_row, selected_col]) == nil
    cell_value = grid.get_cell([selected_row, selected_col])
  else
    cell_value = grid.get_cell([selected_row, selected_col]).value
  end
  display_panel.setpos(2, 1)
  display_panel.addstr("#{cell_value}")

  display_panel.refresh
end

# Helper function to update the formula editor based on the contents of the currently selected cell
def update_formula_editor(formula_editor, grid, row, col)
  formula_editor.clear
  formula_editor.box()
  source_code = grid.get_source_code([row, col]) || ""
  formula_editor.setpos(1, 1)
  formula_editor.addstr("Formula Editor")
  formula_editor.setpos(2, 1)
  formula_editor.addstr("#{source_code}")
  formula_editor.refresh
end

# Helper function that reevaluates and updates the values of all cells in the grid
def update_all_cells(grid, runtime, grid_height, grid_width, main_window, display_panel, formula_editor)
    value = 0
    grid_height.times do |row|
        grid_width.times do |col|
        cell_content = grid.get_cell([row, col])
        if cell_content != nil
          begin
            source_code = grid.get_source_code([row, col])
            ast = evaluate_expression(source_code, runtime)
            result = ast.traverse(Evaluator.new, runtime)
            grid.set_cell([row, col], result, source_code)
            update_grid(result, row, col, main_window)

          rescue StandardError => e
            display_panel.setpos(1, 1)
            display_panel.addstr("Error: #{e.message}")
            display_panel.refresh
            sleep(2)
          end
        end
      end
    end
end
  
# Helper function that serializes and evaluates a given expression
def evaluate_expression(expression, runtime)
  if expression.start_with?('=')
    text = expression[1..-1]
    lexer = Lexer.new(text)
    tokens = lexer.lex
    parser = Parser.new(tokens)
    ast = parser.parse
    return ast
  end

  if expression.match?(/\A-?\d+\z/)
    return IntegerPrimitive.new(expression.to_i, 0, 0)
  elsif expression.match?(/\A-?\d+\.\d+\z/)
    return FloatPrimitive.new(expression.to_f, 0, 0)
  elsif expression.downcase == 'true' || expression.downcase == 'false'
    return BooleanPrimitive.new(expression.downcase, 0, 0)
  else
    return StringPrimitive.new(expression, 0, 0)
  end
end

# Helper function that updates a given cell in the grid
def update_grid(content, row, col, main_window)
  main_window.setpos(row * 2 + 1, col * (CELL_WIDTH + 1) + 5)
  main_window.addstr('      ')
  main_window.setpos(row * 2 + 1, col * (CELL_WIDTH + 1) + 5)
  main_window.addstr(content.value.to_s[0..7])
  main_window.refresh
end

init_screen
stdscr.keypad(true) # Enable special keys

grid_width = 6
grid_height = 6
grid = Grid.new
runtime = Runtime.new(grid)

col_labels = (0..5).to_a

highlight_color = COLOR_RED
start_color
init_pair(1, COLOR_WHITE, highlight_color)

CELL_WIDTH = 7

crmode
noecho

main_window = stdscr

display_panel = main_window.subwin(5, 50, 14, 0)
print_selected_cell_value(display_panel, grid, 0, 0)

formula_editor = main_window.subwin(5, 50, 20, 0)
formula_editor.box()
formula_editor.setpos(1, 1)
formula_editor.addstr('Formula Editor')

col_labels.each_with_index do |label, index|
    main_window.setpos(0, index * (CELL_WIDTH + 1) + 5)
    main_window.addstr(label.to_s.center(CELL_WIDTH))
end

selected_row = 0
selected_col = 0

# Main event loop for handling user input and making UI updates
loop do
  new_row, new_col = selected_row, selected_col

  grid_height.times do |row|
    row_number = row

    main_window.setpos(row * 2 + 1, 0)
    main_window.addstr(row_number.to_s)

    main_window.setpos(row * 2 + 1, 4)
    main_window.addstr("\u2502")
    main_window.setpos(row * 2 + 2, 0)
    main_window.addstr("\u2500" * (grid_width * (CELL_WIDTH + 1) + 1))

    # Print cells
    grid_width.times do |col|
      main_window.setpos(row * 2 + 1, col * (CELL_WIDTH + 1) + 5)
      if grid.get_cell([row, col]) == nil
        cell_value = grid.get_cell([row, col])
      else
        cell_value = grid.get_cell([row, col]).value
      end
      if row == selected_row && col == selected_col
        main_window.attron(color_pair(1) | A_BOLD)
        main_window.addstr("\u2502  #{cell_value.to_s.center(CELL_WIDTH)}  ")
        main_window.attroff(color_pair(1) | A_BOLD)
      else
        main_window.addstr("\u2502  #{cell_value.to_s.center(CELL_WIDTH)}  ")
      end
    end
  end

  main_window.setpos(grid_height * 2 + 1, 0)
  main_window.refresh

  case main_window.getch
    when KEY_UP
      new_row = [selected_row - 1, 0].max
    when KEY_DOWN
      new_row = [selected_row + 1, grid_height - 1].min
    when KEY_LEFT
      new_col = [selected_col - 1, 0].max
    when KEY_RIGHT
      new_col = [selected_col + 1, grid_width - 1].min
    when 27 #Escape key to exit
        close_screen
        exit
    when 9 # Tab key for editing cell values
      formula_editor.setpos(2, 1)
      formula_editor.refresh

      entered_value = ""

      # Handle input in the formula editor
      loop do
        c = formula_editor.getch
        case c
            when 9 # Tab key
            break
          when 27 # Escape key to exit
            close_screen
            exit
            when 127 # Backspace key
            entered_value.chop!
            formula_editor.setpos(2, 1)
            formula_editor.addstr(" " * 48)
            formula_editor.setpos(2, 1)
            formula_editor.addstr("#{entered_value}")
            formula_editor.refresh
            else
            entered_value << c
            formula_editor.setpos(2, 1)
            formula_editor.addstr(" " * 48)
            formula_editor.setpos(2, 1)
            formula_editor.addstr("#{entered_value}")
            formula_editor.refresh
        end
      end

      # Evaluate the entered formula and update grid
      begin
        ast = evaluate_expression(entered_value, runtime)
        result = ast.traverse(Evaluator.new, runtime)
        grid.set_cell([selected_row, selected_col], result, entered_value)

      # Handle errors in expression evaluation
      rescue StandardError => e
        display_panel.setpos(2, 1)
        display_panel.addstr("Error: #{e.message}")
        display_panel.refresh
        sleep(2)
      end

      # Update all cells and display panel after change
      update_all_cells(grid, runtime, grid_height, grid_width, main_window, display_panel, formula_editor)
      print_selected_cell_value(display_panel, grid, selected_row, selected_col)
    end

    # Check if selected cell has changed and update UI
    if new_row != selected_row || new_col != selected_col
      selected_row, selected_col = new_row, new_col
      update_formula_editor(formula_editor, grid, selected_row, selected_col)
      print_selected_cell_value(display_panel, grid, selected_row, selected_col)
    end
end
close_screen