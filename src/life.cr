require "crsfml"
require "./life/*"

window_title = "life " + Config.version

b = Board.new

window = SF::RenderWindow.new(
  SF::VideoMode.new(b.width * Config.tile_width, b.height * Config.tile_height), 
  window_title,
  settings: SF::ContextSettings.new(depth: 24, antialiasing: 0))
window.vertical_sync_enabled = true

cycle = 1
running = Config.auto_start
next_step = false

window.clear Config.board_color 
b.draw window
window.display()

while window.open?
  while event = window.poll_event()
    window.close if event.is_a? SF::Event::Closed

    if event.is_a? SF::Event::KeyReleased
      if event.code == SF::Keyboard::Space
        running = !running
      end
    end

    if event.is_a? SF::Event::KeyPressed
      if event.code == SF::Keyboard::Right
        next_step = true
      elsif event.code == SF::Keyboard::Escape
        window.close
      end
    end
  end

  next if !running && !next_step
  next_step = false

  window.clear Config.board_color 

  b.draw window
  b = b.next

  window.display()

  if Config.print_cycle_interval > 0 && cycle % Config.print_cycle_interval == 0
    puts "Cycle #{cycle}" 
  end

  cycle += 1
  sleep Config.cycle_interval if Config.cycle_interval > 0.0 
end
