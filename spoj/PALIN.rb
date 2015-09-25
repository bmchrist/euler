def get_pair_for_index(index, length)
  length - 1 - index
end

def get_center(length)
  # will be a pair if length is even, and we will give
  # the left most center
  # if length is odd we will give the actual center
  (length-1)/2
end

# Edge cases 999, 0, 899, 101
# Get a number, break it into pieces
input_value = 123
palindrome = input_value.to_s.split("") # this is fine. "2" > "1"

index = 0
pair = get_pair_for_index(0, palindrome.length)
center = get_center(palindrome.length)

# start at the outside (left), and move to center
# if it's odd and index == center, we have nothing left to do at that point
while index < center
  # TODO: consider palindrome to start
  if palindrome[index] == palindrome[pair]
    # They are already equal, move to the next centermost
    index += 1
    pair -= 1
  elsif palindrome[index] > palindrome[pair]
    # Since our left side is larger we should just increase the right side
    palindrome[pair] = palindrome[index]
    index += 1
    pair += 1
  else
    # In this case we need to figure out how to drop this value, which means we need to
    # increase another digit of higher order than this one. The centermost has the
    # lowest impact on the total value of this palindrome, so we'll start there
    # and if it's already maxed out we'll zero it and increase the next highest
    # impact (one above and one below)
    palindrome[index] = 0
    palindrome[pair] = 0


    # # TODO: make this clearer
    # If we ave a single number center let's check it
    if palindrome.length % 2 == 1
      if palindrom[center] < 9
        palindrome[center] += 1
        next
      else
        # if it was 9, 0 it and move outward
        palindrome[center] = 0
        next_highest_left = center - 1
        next_highest_right = center + 1
      end
    else
      # Otherwise let's start at the center
      next_highest_left = center
      next_highest_right = center + 1
    end

    while true # Loop forever. We'll use break inside this
      # TODO Mka esure something doesn't cause our next_highest_x to go past index and pair
      value = palindrom[next_highest_left, next_highest_right].max
      if value < 9
        palindrom[next_highest_left] = value + 1
        palindrom[next_highest_right] = value + 1
        break
      else
        palindrom[next_highest_left] = 0
        palindrom[next_highest_right] = 0
        next_highest_left += 1
        next_highest_right += 1
      end
    end
  end
end
