input = File.read('06.input')

# problem 1

objects = input.split("\n")

all_objects = {}

objects.each do |object|
  a, b = object.split(')')

  a_obj = (all_objects[a] ||= { 'orbits' => [], 'by' => [] })
  b_obj = (all_objects[b] ||= { 'orbits' => [], 'by' => [] })

  a_obj['by'].push(b)
  b_obj['orbits'].push(a)
end

def count_orbits(all_objects, object_name)
  object = all_objects[object_name]

  object['orbits'].size + object['orbits'].map { |v| count_orbits(all_objects, v) }.sum
end

total_orbits = 0

all_objects.keys.each do |object_name|
  total_orbits += count_orbits(all_objects, object_name)
end

p total_orbits

# problem 2

nodes = {}
from_node = nil
to_node = nil

all_objects.each do |key, object|
  nodes[key] = { 'rels' => object['orbits'] + object['by'], 'dist' => nil }

  if object['by'].include?('YOU')
    from_node = key
  end
  if object['by'].include?('SAN')
    to_node = key
  end
end

def min_distance(nodes, from_node, to_node, dist)
  node = nodes[from_node]

  node['rels'].each do |relation|
    if nodes[relation]['dist'].nil? || nodes[relation]['dist'] > dist + 1
      nodes[relation]['dist'] = dist + 1

      min_distance(nodes, relation, to_node, dist + 1)
    end
  end
end

min_distance(nodes, from_node, to_node, 0)

p nodes[to_node]['dist']
