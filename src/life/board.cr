class Board
  getter :width, :height, :matrix, :connect_vertical, :connect_horizontal

  @height : Int32
  @width : Int32
  @tile_width : Int32
  @tile_height: Int32
  @connect_vertical : Bool
  @connect_horizontal : Bool

  def initialize
    @tile_width = Config.tile_width
    @tile_height = Config.tile_height
    @matrix = Array(Array(Bool)).new
    @height = Config.height 
    @width = Config.width 

    if Config.generation_mode == :file
      read_from_file
    elsif Config.generation_mode == :random
      generate_random
    end

    # Defines if the top squares are neighbors of the bottom squares,
    # and the same for left and right border squares
    @connect_vertical = Config.connect_vertical 
    @connect_horizontal = Config.connect_horizontal 
  end

  def initialize(previous : Board)
    @tile_width = Config.tile_width
    @tile_height = Config.tile_height
    @height = previous.matrix.size
    @width = previous.matrix.first.size
    @connect_vertical = previous.connect_vertical
    @connect_horizontal = previous.connect_horizontal

    @matrix = Array(Array(Bool)).new(@height) {
      Array(Bool).new(@width) { false } }
    successor(previous)
  end

  def next
    Board.new(self)
  end

  def successor(previous : Board)
    previous.matrix.each_with_index do |line, x|
      line.each_with_index do |value, y|
        neighbors = previous.get_neighbors(x, y)
        count = neighbors.count(true)
        live = previous.matrix[x][y] # x is the line and y the column

        if live && (count > Config.under_population &&
                    count < Config.over_population)
          @matrix[x][y] = true # survives
        elsif !live && (count >= Config.reproduction_min &&
                    count <= Config.reproduction_max)
          @matrix[x][y] = true # reproduces
        else
          @matrix[x][y] = false # dies or keeps dead
        end
      end
    end
  end

  # x is line and y is the column
  def get_neighbors(x : Int32, y : Int32)
    neighbors = [] of Bool

    prev_x = (x > 0 || @connect_vertical)? x - 1 : nil
    next_x = (x < @height - 1)? x + 1 : (@connect_vertical? 0 : nil)
    prev_y = (y > 0 || @connect_horizontal)? y - 1 : nil
    next_y = (y < @width - 1)? y + 1 : (@connect_horizontal? 0 : nil)

    neighbors << @matrix[prev_x][prev_y] if prev_x && prev_y
    neighbors << @matrix[prev_x][y] if prev_x
    neighbors << @matrix[prev_x][next_y] if prev_x && next_y
    neighbors << @matrix[x][prev_y] if prev_y
    neighbors << @matrix[x][next_y] if next_y
    neighbors << @matrix[next_x][prev_y] if next_x && prev_y
    neighbors << @matrix[next_x][y] if next_x
    neighbors << @matrix[next_x][next_y] if next_x && next_y
    neighbors
  end

  def read_from_file
    board_file = "board.dat"

    File.open(board_file, "r") do |f|
      f.each_line do |line|
        new_line = Array(Bool).new

        line.each_char do |c|
          new_line << (c == '1')
        end

        @matrix << new_line
      end
    end

    @height = @matrix.size
    @width = @matrix.first.size
  end

  def generate_random
    @matrix = Array(Array(Bool)).new(@height) do
      Array(Bool).new(@width) { rand(2) > 0 }
    end
  end

  def draw(window)
    @matrix.each_with_index do |line, l_ind|
      line.each_with_index do |value, c_ind|
        if value
          square = SF::RectangleShape.new()
          square.fill_color = Config.cell_color 
          square.size = SF.vector2(@tile_width, @tile_height)

          square.position = 
            SF.vector2(c_ind * @tile_width, l_ind * @tile_height)

          window.draw square
        end
      end
    end
  end
end
