input = File.read('09.input')

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
  'relative'
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
input_value = 1
phase_set_used = false
step = 0
relative_base = 0

while true do
  state = run_intcode_program(program, input_value, input_value, phase_set_used, step, relative_base)
  break if state[:halted]

  puts state[:output]

  program = state[:program]
  input_value = state[:input_value]
  phase_set_used = state[:phase_set_used]
  step = state[:step]
  relative_base = state[:relative_base]
end

# problem 2

program = input.split(',').map(&:to_i)
input_value = 2
phase_set_used = false
step = 0
relative_base = 0

while true do
  state = run_intcode_program(program, input_value, input_value, phase_set_used, step, relative_base)
  break if state[:halted]

  puts state[:output]

  program = state[:program]
  input_value = state[:input_value]
  phase_set_used = state[:phase_set_used]
  step = state[:step]
  relative_base = state[:relative_base]
end
