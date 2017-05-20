require "crsfml"
require "./life/*"

window_title = "life " + Life::VERSION
width = 40
height = 20
tile_w = 10
tile_h = 10

b = Board.new(tile_w, tile_h)

window = SF::RenderWindow.new(
  SF::VideoMode.new(b.width * tile_w, b.height * tile_h), window_title,
  settings: SF::ContextSettings.new(depth: 24, antialiasing: 1))
window.vertical_sync_enabled = true

while window.open?
  while event = window.poll_event()
    window.close if event.is_a? SF::Event::Closed
  end

  window.clear SF::Color::White
  b.draw window
  b = b.next
  window.display()
  sleep 0.05
end
