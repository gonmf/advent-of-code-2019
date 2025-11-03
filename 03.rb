input = File.read('03.input')

# problem 1

wires = input.split("\n")
wire1 = wires[0].split(',').map { |s| ({ 'dir' => s[0], 'len' => s[1..-1].to_i }) }

wired_already = {}
x = 0
y = 0

wire1.each do |wire|
  dir = wire['dir']
  offset = if dir == 'R'
            [1, 0]
          elsif dir == 'L'
            [-1, 0]
          elsif dir == 'U'
            [0, 1]
          elsif dir == 'D'
            [0, -1]
          end

  shift_x, shift_y = offset
  (0...wire['len']).each do
    x += shift_x
    y += shift_y

    wired_already["#{x}.#{y}"] = 1
  end
end

wire2 = wires[1].split(',').map { |s| ({ 'dir' => s[0], 'len' => s[1..-1].to_i }) }

x = 0
y = 0
min_distance = 0

wire2.each do |wire|
  dir = wire['dir']
  offset = if dir == 'R'
            [1, 0]
          elsif dir == 'L'
            [-1, 0]
          elsif dir == 'U'
            [0, 1]
          elsif dir == 'D'
            [0, -1]
          end

  shift_x, shift_y = offset
  (0...wire['len']).each do
    x += shift_x
    y += shift_y

    if wired_already["#{x}.#{y}"]
      distance = x.abs + y.abs
      min_distance = min_distance == 0 ? distance : [distance, min_distance].min
    end
  end
end

p min_distance

# problem 2

wires = input.split("\n")
wire1 = wires[0].split(',').map { |s| ({ 'dir' => s[0], 'len' => s[1..-1].to_i }) }

wire_step1 = {}
x = 0
y = 0
steps = 1

wire1.each do |wire|
  dir = wire['dir']
  offset = if dir == 'R'
            [1, 0]
          elsif dir == 'L'
            [-1, 0]
          elsif dir == 'U'
            [0, 1]
          elsif dir == 'D'
            [0, -1]
          end

  shift_x, shift_y = offset
  (0...wire['len']).each do
    x += shift_x
    y += shift_y

    if wire_step1["#{x}.#{y}"].nil?
      wire_step1["#{x}.#{y}"] = steps
    end

    steps += 1
  end
end

wire2 = wires[1].split(',').map { |s| ({ 'dir' => s[0], 'len' => s[1..-1].to_i }) }

wire_step2 = {}
x = 0
y = 0
steps = 1

wire2.each do |wire|
  dir = wire['dir']
  offset = if dir == 'R'
            [1, 0]
          elsif dir == 'L'
            [-1, 0]
          elsif dir == 'U'
            [0, 1]
          elsif dir == 'D'
            [0, -1]
          end

  shift_x, shift_y = offset
  (0...wire['len']).each do
    x += shift_x
    y += shift_y

    if wire_step1["#{x}.#{y}"] && wire_step2["#{x}.#{y}"].nil?
      wire_step2["#{x}.#{y}"] = wire_step1["#{x}.#{y}"] + steps
    end

    steps += 1
  end
end

p wire_step2.values.min
