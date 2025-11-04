input = File.read('08.input')

# problem 1

wide, tall, pixels = input.split("\n")

wide = wide.to_i
tall = tall.to_i
pixels = pixels.chars.map(&:to_i)

min_zero_digits = nil
one_by_two = nil
layers = []

pixels.each_slice(wide * tall) do |slice|
  layers.push(slice)
  zero_digits = slice.count { |v| v == 0 }

  if min_zero_digits.nil? || min_zero_digits > zero_digits
    min_zero_digits = zero_digits
    one_by_two = slice.count { |v| v == 1 } * slice.count { |v| v == 2 }
  end
end

p one_by_two

# problem 2

(0...(wide * tall)).each do |pos|
  layer_i = 0
  while layer_i < layers.size
    if layers[layer_i][pos] == 2
      layer_i += 1
    else
      layers[0][pos] = layers[layer_i][pos]
      break
    end
  end
end

layers[0].each_slice(wide) do |slice|
  puts slice.map { |v| v == 1 ? '0' : ' ' }.join(' ')
end
