require "crsfml"
require "./life/*"

window_title = "life " + Life::VERSION

b = Board.new

window = SF::RenderWindow.new(
  SF::VideoMode.new(b.width * Life::TileWidth, b.height * Life::TileHeight), 
  window_title,
  settings: SF::ContextSettings.new(depth: 24, antialiasing: 0))
window.vertical_sync_enabled = true

cicle = 1
running = Life::AutoStart
next_step = false

window.clear Life::BoardColor 
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
      end
    end
  end

  next if !running && !next_step
  next_step = false

  window.clear Life::BoardColor

  b.draw window
  b = b.next

  window.display()

  puts "Cycle #{cicle}" #if cicle % 100 == 0
  cicle += 1
  sleep Life::CycleInterval if Life::CycleInterval > 0.0 
end
