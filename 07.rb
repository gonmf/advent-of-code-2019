input = File.read('07.input')

# program 1

def get_value(program, value, mode)
  if mode == 'position'
    program[program[value]]
  else
    program[value]
  end
end

def run_intcode_program(program, phase_set, phase_setting, input_value, step)
  while true do
    if step < 0 || step >= program.size
      puts 'error instruction out of bounds'
      exit
    end

    op = program[step]
    if op == 99
      return [nil, nil, nil, nil, true]
      # break
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
        program[program[step + 1]] = phase_set ? input_value : phase_setting
      else
        program[step + 1] = phase_set ? input_value : phase_setting
      end
      phase_set = true
      op_size = 2
    elsif instruction == 4
      return [get_value(program, step + 1, mode_1st_param), program, step + 2, phase_set, false]
      # output.push(get_value(program, step + 1, mode_1st_param))
      # op_size = 2
    elsif instruction == 5
      arg1 = get_value(program, step + 1, mode_1st_param)
      arg2 = get_value(program, step + 2, mode_2nd_param)
      if arg1 != 0
        op_size = 0
        step = arg2
        if arg2.nil?
          puts 'nil step'
          exit
        end
      else
        op_size = 3
      end
    elsif instruction == 6
      arg1 = get_value(program, step + 1, mode_1st_param)
      arg2 = get_value(program, step + 2, mode_2nd_param)
      if arg1 == 0
        op_size = 0
        step = arg2
        if arg2.nil?
          puts 'nil step'
          exit
        end
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

  # if output.size != 1
    puts 'unexpected output size'
    exit
  # end

  # output.first
end

program = input.split(',').map(&:to_i)

max_seq = nil

(0..4).each do |v1|
  (0..4).each do |v2|
    next if v1 == v2
    (0..4).each do |v3|
      next if v1 == v3 || v2 == v3
      (0..4).each do |v4|
        next if v1 == v4 || v2 == v4 || v3 == v4
        (0..4).each do |v5|
          next if v1 == v5 || v2 == v5 || v3 == v5 || v4 == v5

          r1, = run_intcode_program(program.clone, false, v1, 0, 0)
          r2, = run_intcode_program(program.clone, false, v2, r1, 0)
          r3, = run_intcode_program(program.clone, false, v3, r2, 0)
          r4, = run_intcode_program(program.clone, false, v4, r3, 0)
          r5, = run_intcode_program(program.clone, false, v5, r4, 0)
          max_seq = max_seq.nil? ? r5 : [max_seq, r5].max
        end
      end
    end
  end
end

p max_seq

# program 2

max_seq = nil

(5..9).each do |v1|
  (5..9).each do |v2|
    next if v1 == v2
    (5..9).each do |v3|
      next if v1 == v3 || v2 == v3
      (5..9).each do |v4|
        next if v1 == v4 || v2 == v4 || v3 == v4
        (5..9).each do |v5|
          next if v1 == v5 || v2 == v5 || v3 == v5 || v4 == v5

          last_output_signal = nil

          step1 = 0
          step2 = 0
          step3 = 0
          step4 = 0
          step5 = 0
          program1 = program.clone
          program2 = program.clone
          program3 = program.clone
          program4 = program.clone
          program5 = program.clone
          phase_set1 = false
          phase_set2 = false
          phase_set3 = false
          phase_set4 = false
          phase_set5 = false
          r5 = 0

          while true
            r1, program1, step1, phase_set1, halted = run_intcode_program(program1, phase_set1, v1, r5, step1)
            break if halted
            r2, program2, step2, phase_set2, halted = run_intcode_program(program2, phase_set2, v2, r1, step2)
            break if halted
            r3, program3, step3, phase_set3, halted = run_intcode_program(program3, phase_set3, v3, r2, step3)
            break if halted
            r4, program4, step4, phase_set4, halted = run_intcode_program(program4, phase_set4, v4, r3, step4)
            break if halted
            r5, program5, step5, phase_set5, halted = run_intcode_program(program5, phase_set5, v5, r4, step5)
            if !r5.nil?
              last_output_signal = r5
            end
            break if halted
          end

          max_seq = max_seq.nil? && !last_output_signal.nil? ? last_output_signal : [max_seq, last_output_signal].max
        end
      end
    end
  end
end

p max_seq
