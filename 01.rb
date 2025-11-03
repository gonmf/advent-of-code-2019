input = File.read('01.input')

# problem 1

puts input.split("\n").map { |v| (v.to_i / 3).to_i - 2 }.sum

# problem 2

def fuel(v)
  v = (v / 3).to_i - 2
  v > 8 ? v + fuel(v) : v
end

puts fuel(100756)
puts input.split("\n").map { |v| fuel(v.to_i) }.sum
