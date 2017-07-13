#---
# Excerpted from "Learn Game Programming with Ruby",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/msgpkids for more book information.
#---
require 'gosu'
require 'chipmunk'

class Escape < Gosu::Window
	attr_reader :space

	DAMPING = 0.90 #determines how objects slow down
	GRAVITY = 400.0

	def initialize
		super 800,800,false
    self.caption = "Escape"
		@game_over = false
		@space = CP::Space.new
		@background = Gosu::Image.new('images/background.png', tileable: true)
		@space.damping = DAMPING
		@spce.gravity = CP::Vec2.new(0,0, GRAVITY)
  end

  def draw

  end

  def update

  end

end

window = Escape.new
window.show
