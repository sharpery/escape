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
require_relative 'boulder'

class Escape < Gosu::Window
	attr_reader :space

	DAMPING = 0.90 #determines how objects slow down
	GRAVITY = 400.0
	BOULDER_FREQUENCY = 0.01

	def initialize
		super 800,800,false
    self.caption = "Escape"
		@game_over = false
		@space = CP::Space.new
		@background = Gosu::Image.new('images/background.png', tileable: true)
		@space.damping = DAMPING
		@space.gravity = CP::Vec2.new(0.0,GRAVITY)
		@boulders = []
  end

  def draw
		@background.draw(0,0,0)
		@background.draw(0,529,0) #one image doesn't fill window
		@boulders.each do |boulder|
			boulder.draw
		end
  end

  def update
		unless @game_over
			10.times do
				@space.step(1.0/600) #update 600x/sec
			end
			if rand < BOULDER_FREQUENCY
				@boulders.push Boulder.new(self, 200 + rand(400), -20)
				#boulder added off the top of the window, between 1/4 and 3/4 of the window width
			end
		end
  end

end

window = Escape.new
window.show
