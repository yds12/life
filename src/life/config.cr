module Life
  ConfigFile = "life.cfg"

  Width = 300
  Height = 150
  TileWidth = 4
  TileHeight = 4
  ConnectVertical = true
  ConnectHorizontal = true

  CycleInterval = 0.01
  AutoStart = false
  PrintCycleInterval = 100

  CellColor = SF.color(128 + rand(128), 128 + rand(128), 128 + rand(128))
  BoardColor = SF.color(rand(128), rand(128), rand(128))

  # Mode of generation of the board:
  # :file read from file
  # :random randomly generated
  GenerationMode = :random

  UnderPopulation = 1 
  OverPopulation = 4
  ReproductionMin = 3
  ReproductionMax = 3
end

class Config
  @@singleton = Config.new

#  macro getter(*names)
#    {% for name in names %}
#      def {{name}}
#        @{{name}}
#      end
#
#      def self.{{name}}
#        @@singleton.{{name}}
#      end
#    {% end %}
#  end

  macro getter(name, type)
    @{{name}} : {{type}}

    def {{name}}
      @{{name}}
    end

    def self.{{name}}
      @@singleton.{{name}}
    end
  end

  getter height, Int32
  getter width, Int32
  getter tile_height, Int32
  getter tile_width, Int32
  getter connect_vertical, Bool
  getter connect_horizontal, Bool
  getter print_cycle_interval, Int32
  getter cycle_interval, Float64
  getter auto_start, Bool
  getter cell_color, SF::Color
  getter board_color, SF::Color
  getter generation_mode, Symbol
  getter under_population, Int32
  getter over_population, Int32
  getter reproduction_min, Int32
  getter reproduction_max, Int32

  def self.version
    Life::VERSION
  end

  def initialize
    # Initialize the instance variables with default values
    @width = Life::Width
    @height = Life::Height
    @tile_width = Life::TileWidth
    @tile_height = Life::TileHeight
    @connect_vertical = Life::ConnectVertical
    @connect_horizontal = Life::ConnectHorizontal
    @cycle_interval = Life::CycleInterval
    @print_cycle_interval = Life::PrintCycleInterval
    @auto_start = Life::AutoStart
    @cell_color = Life::CellColor
    @board_color = Life::BoardColor 
    @generation_mode = Life::GenerationMode
    @under_population = Life::UnderPopulation
    @over_population = Life::OverPopulation
    @reproduction_min = Life::ReproductionMin
    @reproduction_max = Life::ReproductionMax

    # If config file exists, set the variables with those values
    if File.exists?(Life::ConfigFile)
      lines = Array(String).new

      File.open(Life::ConfigFile, "r") do |f|
        f.each_line do |line|
          lines << line
        end
      end

      skip = false

      lines.each do |line|
        next if line.strip.size == 0 # empty line
        next if line.strip[0] == '#' # comment line

        parts = line.split("=")
        prop_name = parts[0].strip.downcase
        prop_val = parts[1].strip.downcase

        if prop_name == "usedefault" && prop_val.strip == "true"
          skip = true
          break
        end
      end

      unless skip
        lines.each do |line|
          next if line.strip.size == 0 # empty line
          next if line.strip[0] == '#' # comment line

          parts = line.split("=")
          prop_name = parts[0].strip.downcase
          prop_val = parts[1].strip.downcase
          
          set_variable prop_name, prop_val
        end
      end
    end
  end

  def set_variable(prop_name, prop_val)
    case prop_name
      when "width" 
        @width = prop_val.strip.to_i
      when "height" 
        @height = prop_val.strip.to_i
      when "tilewidth" 
        @tile_width = prop_val.strip.to_i
      when "tileheight" 
        @tile_height = prop_val.strip.to_i
      when "connecthorizontal" 
        @connect_horizontal = (prop_val.strip == "true")
      when "connectvertical" 
        @connect_vertical = (prop_val.strip == "true")
      when "cycleinterval"
        @cycle_interval = prop_val.strip.to_f
      when "autostart"
        @auto_start = (prop_val.strip == "true")
      when "printcycleinterval"
        @print_cycle_interval = prop_val.strip.to_i
      when "cellcolor"
        arr = prop_val.split(",")
        @cell_color = SF.color(arr[0].strip.to_i, arr[1].strip.to_i,
                               arr[2].strip.to_i)
      when "boardcolor"
        arr = prop_val.split(",")
        @board_color = SF.color(arr[0].strip.to_i, arr[1].strip.to_i,
                                arr[2].strip.to_i)
      when "generationmode"
        @generation_mode = if prop_val.strip == "file"
                            :file
                          else
                            :random
                          end
      when "underpopulation"
        @under_population = prop_val.strip.to_i
      when "overpopulation"
        @over_population = prop_val.strip.to_i
      when "reproductionmin"
        @reproduction_min = prop_val.strip.to_i
      when "reproductionmax"
        @reproduction_max = prop_val.strip.to_i
    end
  end
end
