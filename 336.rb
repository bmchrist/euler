require 'awesome_print'
def debug(message)
  puts message if ENV['LOG_LEVEL'] == 'debug'
end

def num_to_letter(num)
  num.to_s(26).tr('0-9', 'A-Z')
end

def solve(arr)
  moves_count = 0
  end_state = arr.sort # Compare to what it should be at the end

  # Go through and get each one in place
  (0..(arr.length-1)).each do |desired_spot|
    # start at x and find its current spot by going through the array
    x = desired_spot
    # find the location of the desired letter
    while arr[x] != desired_spot
      debug "x: #{x} is currently #{arr[x]} and we want #{end_state[desired_spot]}"
      fail "out of bounds #{x}" if arr[x].nil?
      x += 1
    end

    # now that x is at the current spot of the item
    if x == desired_spot
      # do nothing
    else
      debug "rotate to end #{arr.length-x}"
      # Rotate the desired item to the end
      moves_count += 1 if rotate(number: arr.length - x, arr: arr)
      debug "rotate to end #{arr.length-desired_spot}"
      # and now rotate the end item into position
      moves_count += 1 if rotate(number: arr.length - desired_spot, arr: arr)
    end
  end

  if arr != end_state
    debug "arr"
    debug arr
    debug "end_state"
    debug end_state
    fail "arrays did not match"
  end

  moves_count
end

def rotate(number:, arr:)
  return false if number <= 1

  i = arr.length - number
  j = arr.length - 1

  while i < j
    debug "i: #{i}, j: #{j}, arr: #{arr.join(',')}"
    fail "out of bounds" if arr[i].nil?
    fail "out of bounds" if arr[j].nil?

    temp = arr[i]
    arr[i] = arr[j]
    arr[j] = temp
    i += 1
    j -= 1
  end
  true
end

def solve_all(length:, maximix:)
  fail "length too long for alpha" if length > 26
  arrangements = solve_permutations(list: (0..length-1).to_a, locked: 0)

  data = {}

  arrangements.each do |arrangement|
    (data[arrangement[0]] ||= []) << arrangement[1]
  end
  keys = data[data.keys.max].map do |train|
    train.map{ |num| num_to_letter(num) }.join("")
  end
  keys.sort[maximix-1]
end

def solve_permutations(list:, locked:)
  arrangements = []
  if locked == list.length
    # if all are locked, solve it and return the count
    debug "\n-------------------------"
    puts "solving #{list.join(",")}"
    debug "-------------------------"
    return [[solve(list.dup), list.dup]]
  else
    # solve with each each remaining letter as the locked on in this spot.
    # This will unsort the list a bit, but as long
    # as we're only unsorting the part after the locked letter it's fine
    x = locked
    while x < list.length
      if x != locked
        tmp = list[locked]
        list[locked] = list[x]
        list[x] = tmp
      end
      arrangements += solve_permutations(list: list.dup, locked: locked+1)
      x += 1
    end
    return arrangements
  end
end

# Should only be 24, getting way too many
puts solve_all(length: 11, maximix: 2011)
