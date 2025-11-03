input = File.read('05.input')

# problem 1

program = input.split(',').map(&:to_i)

def get_value(program, value, mode)
  if mode == 'position'
    program[program[value]]
  else
    program[value]
  end
end

step = 0
output = []

while true do
  op = program[step]
  if op == 99
    break
  end

  instruction = op % 100

  mode_1st_param = ((op / 100).to_i % 10) == 0 ? 'position' : 'immediate'
  mode_2nd_param = ((op / 1000).to_i % 10) == 0 ? 'position' : 'immediate'
  mode_3rd_param = ((op / 10000).to_i % 10) == 0 ? 'position' : 'immediate'

  op_size = 4

  if instruction == 1
    arg1 = get_value(program, step + 1, mode_1st_param)
    arg2 = get_value(program, step + 2, mode_2nd_param)

    if mode_3rd_param == 'position'
      program[program[step + 3]] = arg1 + arg2
    else
      program[step + 3] = arg1 + arg2
    end
  elsif instruction == 2
    arg1 = get_value(program, step + 1, mode_1st_param)
    arg2 = get_value(program, step + 2, mode_2nd_param)

    if mode_3rd_param == 'position'
      program[program[step + 3]] = arg1 * arg2
    else
      program[step + 3] = arg1 * arg2
    end
  elsif instruction == 3
    if mode_1st_param == 'position'
      program[program[step + 1]] = 1
    else
      program[step + 1] = 1
    end
    op_size = 2
  elsif instruction == 4
    output.push(get_value(program, step + 1, mode_1st_param))
    op_size = 2
  end

  step += op_size
end

p output.last

# problem 2

program = input.split(',').map(&:to_i)

step = 0
output = []

while true do
  if step < 0 || step >= program.size
    puts 'error instruction out of bounds'
    exit
  end

  op = program[step]
  if op == 99
    break
  end

  instruction = op % 100

  mode_1st_param = ((op / 100).to_i % 10) == 0 ? 'position' : 'immediate'
  mode_2nd_param = ((op / 1000).to_i % 10) == 0 ? 'position' : 'immediate'
  mode_3rd_param = ((op / 10000).to_i % 10) == 0 ? 'position' : 'immediate'

  op_size = 4

  if instruction == 1
    arg1 = get_value(program, step + 1, mode_1st_param)
    arg2 = get_value(program, step + 2, mode_2nd_param)

    if mode_3rd_param == 'position'
      program[program[step + 3]] = arg1 + arg2
    else
      program[step + 3] = arg1 + arg2
    end
  elsif instruction == 2
    arg1 = get_value(program, step + 1, mode_1st_param)
    arg2 = get_value(program, step + 2, mode_2nd_param)

    if mode_3rd_param == 'position'
      program[program[step + 3]] = arg1 * arg2
    else
      program[step + 3] = arg1 * arg2
    end
  elsif instruction == 3
    if mode_1st_param == 'position'
      program[program[step + 1]] = 5
    else
      program[step + 1] = 1
    end
    op_size = 2
  elsif instruction == 4
    output.push(get_value(program, step + 1, mode_1st_param))
    op_size = 2
  elsif instruction == 5
    arg1 = get_value(program, step + 1, mode_1st_param)
    arg2 = get_value(program, step + 2, mode_2nd_param)
    if arg1 != 0
      op_size = 0
      step = arg2
    else
      op_size = 3
    end
  elsif instruction == 6
    arg1 = get_value(program, step + 1, mode_1st_param)
    arg2 = get_value(program, step + 2, mode_2nd_param)
    if arg1 == 0
      op_size = 0
      step = arg2
    else
      op_size = 3
    end
  elsif instruction == 7
    arg1 = get_value(program, step + 1, mode_1st_param)
    arg2 = get_value(program, step + 2, mode_2nd_param)

    to_store = arg1 < arg2 ? 1 : 0

    if mode_3rd_param == 'position'
      program[program[step + 3]] = to_store
    else
      program[step + 3] = to_store
    end
  elsif instruction == 8
    arg1 = get_value(program, step + 1, mode_1st_param)
    arg2 = get_value(program, step + 2, mode_2nd_param)

    to_store = arg1 == arg2 ? 1 : 0

    if mode_3rd_param == 'position'
      program[program[step + 3]] = to_store
    else
      program[step + 3] = to_store
    end
  end

  step += op_size
end

p output.last
