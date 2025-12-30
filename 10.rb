require 'set'

input = File.read('10.input')

# problem 1

def reduce_deltas(delta_x, delta_y)
  d = [delta_x.abs, delta_y.abs].max

  while d > 1
    if ((delta_x % d) == 0) && ((delta_y % d) == 0)
      return [delta_x / d, delta_y / d]
    end

    d -= 1
  end

  [delta_x, delta_y]
end

galaxy = Set.new
min_x = nil
max_x = nil
min_y = nil
max_y = nil
best_asteroids_seen = 0
best_asteroid = nil

input.split("\n").map.with_index do |l, y|
  l.split('').each.with_index do |v, x|
    next unless v == '#'

    galaxy.add([x.to_i, y.to_i])

    min_x = min_x.nil? ? x : [min_x, x].min
    max_x = max_x.nil? ? x : [max_x, x].max
    min_y = min_y.nil? ? y : [min_y, y].min
    max_y = max_y.nil? ? y : [max_y, y].max
  end
end

galaxy.to_a.each.with_index do |asteroid1, i|
  asteroids_seen = Set.new

  galaxy.to_a.each.with_index do |asteroid2, j|
    next if j == i

    delta_x = asteroid2[0] - asteroid1[0]
    delta_y = asteroid2[1] - asteroid1[1]

    delta_x, delta_y = reduce_deltas(delta_x, delta_y)

    x, y = asteroid1
    x += delta_x
    y += delta_y

    while (x >= min_x && y >= min_y && x <= max_x && y <= max_y) do
      if galaxy.include?([x, y])
        asteroids_seen.add([x, y])
        break
      end

      x += delta_x
      y += delta_y
    end
  end

  if asteroids_seen.size > best_asteroids_seen
    best_asteroids_seen = asteroids_seen.size
    best_asteroid = asteroid1
  end
end

p best_asteroids_seen

# problem 2

center_x, center_y = best_asteroid

destroyed = 0
prev_min_angle = -1

galaxy_arr = galaxy.to_a.reject { |a| a == best_asteroid }

def calc_angle(a, b)
  dx = b[0] - a[0]
  dy = b[1] - a[1]

  angle = Math.atan2(dx, dy) * 180.0 / Math::PI
  angle %= 360
  angle.round(3)
end

def distance(a, b)
  ax, ay = a
  bx, by = b

  (ax - bx).abs + (ay - by).abs
end

while true
  next_asteroids = galaxy_arr.select { |asteroid| calc_angle(best_asteroid, asteroid) > prev_min_angle }

  min_angle = next_asteroids.map { |asteroid| calc_angle(best_asteroid, asteroid) }.min

  all_candidates = next_asteroids.select { |asteroid| calc_angle(best_asteroid, asteroid) == min_angle }

  closest = all_candidates.sort_by { |asteroid| distance(best_asteroid, asteroid) }[0]

  galaxy_arr = galaxy_arr.reject { |a| a == closest }
  destroyed += 1

  if destroyed == 200
    p closest[0] * 100 + closest[1]
    break
  end
end
