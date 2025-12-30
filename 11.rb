require 'set'

input = File.read('11.input')

# problem 1

def get_value(program, value, mode, relative_base)
  address = if mode == 'position'
              program[value] || 0
            elsif mode == 'relative'
              (program[value] || 0) + relative_base
            else
              value
            end

  program[address] || 0
end

def set_value(program, value, mode, relative_base, to_set)
  address = if mode == 'position'
              program[value] || 0
            elsif mode == 'relative'
              (program[value] || 0) + relative_base
            end

  program[address] = to_set
end

def read_mode(header)
  return 'position'  if header == 0
  return 'immediate' if header == 1
  return 'relative'  if header == 2
  puts'ERROR'
  puts header
  exit
end

def run_intcode_program(program, phase_setting = 0, input_value = 0, phase_set_used = false, step = 0, relative_base = 0)
  if program.is_a?(Array)
    program = program.map.with_index { |v, i| [i, v] }.to_h
  end

  while true do
    op = program[step] || 0
    if op == 99
      return {
        output: nil,
        program: program,
        step: step,
        halted: true,
        phase_set_used: phase_set_used,
        relative_base: relative_base
      }
    end

    instruction = op % 100
    mode_1st_param = read_mode((op / 100).to_i % 10)
    mode_2nd_param = read_mode((op / 1000).to_i % 10)
    mode_3rd_param = read_mode((op / 10000).to_i % 10)

    op_size = 4

    if instruction == 1
      arg1 = get_value(program, step + 1, mode_1st_param, relative_base)
      arg2 = get_value(program, step + 2, mode_2nd_param, relative_base)

      set_value(program, step + 3, mode_3rd_param, relative_base, arg1 + arg2)
    elsif instruction == 2
      arg1 = get_value(program, step + 1, mode_1st_param, relative_base)
      arg2 = get_value(program, step + 2, mode_2nd_param, relative_base)

      set_value(program, step + 3, mode_3rd_param, relative_base, arg1 * arg2)
    elsif instruction == 3
      set_value(program, step + 1, mode_1st_param, relative_base, phase_set_used ? input_value : phase_setting)
      phase_set_used = true
      op_size = 2
    elsif instruction == 4
      return {
        output: get_value(program, step + 1, mode_1st_param, relative_base),
        program: program,
        step: step + 2,
        halted: false,
        phase_set_used: phase_set_used,
        relative_base: relative_base,
      }
    elsif instruction == 5
      arg1 = get_value(program, step + 1, mode_1st_param, relative_base)
      arg2 = get_value(program, step + 2, mode_2nd_param, relative_base)
      step = arg1 != 0 ? arg2 : step + 3
      op_size = 0
    elsif instruction == 6
      arg1 = get_value(program, step + 1, mode_1st_param, relative_base)
      arg2 = get_value(program, step + 2, mode_2nd_param, relative_base)
      step = arg1 == 0 ? arg2 : step + 3
      op_size = 0
    elsif instruction == 7
      arg1 = get_value(program, step + 1, mode_1st_param, relative_base)
      arg2 = get_value(program, step + 2, mode_2nd_param, relative_base)

      set_value(program, step + 3, mode_3rd_param, relative_base, arg1 < arg2 ? 1 : 0)
    elsif instruction == 8
      arg1 = get_value(program, step + 1, mode_1st_param, relative_base)
      arg2 = get_value(program, step + 2, mode_2nd_param, relative_base)

      set_value(program, step + 3, mode_3rd_param, relative_base, arg1 == arg2 ? 1 : 0)
    elsif instruction == 9
      arg1 = get_value(program, step + 1, mode_1st_param, relative_base)
      relative_base += arg1
      op_size = 2
    end

    step += op_size
  end
end

program = input.split(',').map(&:to_i)
step = 0
matrix = {}
robot_x = 0
robot_y = 0
robot_dir = [0, -1]
painted_once = Set.new

while true do
  pos_key = [robot_x, robot_y].join(',')

  input_value = matrix[pos_key] == true ? 1 : 0
  state = run_intcode_program(program, input_value, input_value, false, step, 0)
  break if state[:halted]

  program = state[:program]
  step = state[:step]
  output1 = state[:output]

  state = run_intcode_program(program, input_value, input_value, false, step, 0)
  break if state[:halted]

  program = state[:program]
  step = state[:step]
  output2 = state[:output]

  matrix[pos_key] = output1 == 0 ? false : true
  painted_once.add(pos_key)

  if output2 == 0
    # turn left
    robot_dir = [robot_dir[1], -robot_dir[0]]
  else
    # turn right
    robot_dir = [-robot_dir[1], robot_dir[0]]
  end

  x, y = robot_dir
  robot_x += x
  robot_y += y
end

p painted_once.size

# problem 2

program = input.split(',').map(&:to_i)
step = 0
matrix = {}
robot_x = 0
robot_y = 0
robot_dir = [0, -1]
min_x = 9999999
max_x = -9999999
min_y = 9999999
max_y = -9999999

matrix[[robot_x, robot_y].join(',')] = true

while true do
  min_x = [min_x, robot_x].min
  max_x = [max_x, robot_x].max
  min_y = [min_y, robot_y].min
  max_y = [max_y, robot_y].max

  pos_key = [robot_x, robot_y].join(',')

  input_value = matrix[pos_key] == true ? 1 : 0
  state = run_intcode_program(program, input_value, input_value, false, step, 0)
  break if state[:halted]

  program = state[:program]
  step = state[:step]
  output1 = state[:output]

  state = run_intcode_program(program, input_value, input_value, false, step, 0)
  break if state[:halted]

  program = state[:program]
  step = state[:step]
  output2 = state[:output]

  matrix[pos_key] = output1 == 0 ? false : true

  if output2 == 0
    # turn left
    robot_dir = [robot_dir[1], -robot_dir[0]]
  else
    # turn right
    robot_dir = [-robot_dir[1], robot_dir[0]]
  end

  x, y = robot_dir
  robot_x += x
  robot_y += y
end

(min_y..max_y).each do |y|
  puts (min_x..max_x).to_a.map { |x| matrix[[x, y].join(',')] == true ? '#' : '.' }.join('')
end
