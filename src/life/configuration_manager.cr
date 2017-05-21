module Life
  ConfigFile = "life.cfg"
  ConfigManager = ConfigurationManager.new

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

class ConfigurationManager
  def initialize
    if File.exists?(Life::ConfigFile)
    end
  end
end
