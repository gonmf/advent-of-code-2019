input = File.read('02.input')

# problem 1

program = input.split(',').map(&:to_i)

program[1] = 12
program[2] = 2

def run(program, step = 0)
  op = program[step]

  return if op == 99

  arg1 = program[program[step + 1]]
  arg2 = program[program[step + 2]]

  if op == 1
    program[program[step + 3]] = arg1 + arg2
  elsif op == 2
    program[program[step + 3]] = arg1 * arg2
  else
    puts 'bad run'
    return
  end

  run(program, step + 4)
end

run(program)

puts program[0]

# program 2

(0..99).each do |noun|
  (0..99).each do |verb|
    program = input.split(',').map(&:to_i)
    program[1] = noun
    program[2] = verb

    run(program)
    if program[0] == 19690720
      puts 100 * noun + verb
      exit
    end
  end
end
