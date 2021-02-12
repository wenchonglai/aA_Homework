def sluggish_octopus(fishes)
  sorted = false

  until sorted
    sorted = true
    
    fishes[0...-1].each_with_index do |fish, i|
      if fishes[i].length < fishes[i + 1].length
        fishes[i], fishes[i + 1] = fishes[i + 1], fishes[i]
        sorted = false
      end
    end
  end

  fishes.first
end

def dominant_octopus(fishes)
  len = fishes.length

  return '' if len == 0
  return fishes.first if len == 1

  h_len = len / 2
  l, r = dominant_octopus(fishes[0...h_len]), dominant_octopus(fishes[h_len..-1])

  return (l.length < r.length) ? r : l
end

def clever_octopus(fishes)
  fishes.inject(''){|max, fish| max = fish.length > max.length ? fish : max }
end

def slow_dance(dir, arr)
  arr.each_with_index {|direction, i| return i if dir == direction}
end

def fast_dance(dir, hash)
  hash[dir]
end

fishes = ['fish', 'fiiish', 'fiiiiish', 'fiiiish', 'fffish', 'ffiiiiisshh', 'fsh', 'fiiiissshhhhhh']
tiles_array = ["up", "right-up", "right", "right-down", "down", "left-down", "left",  "left-up" ]
tiles_hash = {"up" => 0, "right-up" => 1, "right" => 2, "right-down" => 3, "down" => 4, "left-down" => 5, "left" => 6,  "left-up" => 7}

p '-------'
p sluggish_octopus(fishes)
p dominant_octopus(fishes)
p clever_octopus(fishes)

p '-------'
p slow_dance("up", tiles_array)
p slow_dance("right-down", tiles_array)

p '-------'
p fast_dance("up", tiles_hash)
p fast_dance("right-down", tiles_hash)