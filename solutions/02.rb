def move(snake, directions)
  snake[1..-1].
  push([snake.last[0] + directions[0], snake.last[1] + directions[1]])
end

def grow(snake, directions)
  snake.dup.
  push([snake.last[0] + directions[0], snake.last[1] + directions[1]])
end

def new_food(food, snake, dimensions)
  (all_positions_available(food, snake, dimensions)).sample
end


def all_positions_available(food, snake, dimensions)
  all_positions(dimensions) - food - snake
end


def all_positions(dimensions)
  positions_x = (0...dimensions[:width]).to_a
  positions_y = (0...dimensions[:height]).to_a
  positions = positions_x.product(positions_y)
end

def obstacle_ahead?(snake, directions, dimensions)
  next_move = [snake.last[0] + directions[0], snake.last[1] + directions[1]]
  (snake.include? next_move) ||
  (not ((all_positions(dimensions)).include? next_move))
end

def danger?(snake, direction, dimensions)
  next_move = move(snake, direction)
  obstacle_ahead?(snake, direction, dimensions) or
  obstacle_ahead?(next_move, direction, dimensions)
end