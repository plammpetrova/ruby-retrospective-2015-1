def move(snake, direction)
  grown_up_snake = snake.dup
  grown_up_snake.delete_at(0)
  grow(grown_up_snake, direction)
end

def all_positions_available(food, snake, dimensions)
  all_positions(dimensions) - food - snake
end

def new_food(food, snake, dimensions)
  (all_possitions_available(food, snake, dimensions)).sample
end

def grow(snake, direction)
  grown_up_snake = snake.dup
  head = grown_up_snake.last
  grown_up_snake.push([head[0] + direction[0], head[1] + direction[1]])
end

def all_positions(dimensions)
  width_of_field = (dimensions[:width]).pred
  height_of_field = (dimensions[:height]).pred
  ((0..width_of_field).to_a).product((0..height_of_field).to_a)
end

def obstacle_ahead?(snake, direction, dim)
  next_move = (grow(snake, direction)).last
  (snake.include? next_move) or
  (not ((all_positions(dim)).include? next_move))
end

def danger?(snake, direction, dimensions)
  next_move = move(snake, direction)
  obstacle_ahead?(snake, direction, dimensions) or
  obstacle_ahead?(next_move, direction, dimensions)
end