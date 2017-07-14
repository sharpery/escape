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
require_relative 'platform'
require_relative 'wall'
require_relative 'chip'
require_relative 'moving_platform'
require_relative 'camera'

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
		@player = Chip.new(self, 70, 1500)
		@camera = Camera.new(self, 1600, 1600)
		@camera.center_on(@player, 400, 200)
		@background = Gosu::Image.new('images/background.png', tileable: true)
		@space.damping = DAMPING
		@space.gravity = CP::Vec2.new(0.0,GRAVITY)
		@boulders = []
		@platforms = make_platforms
		@floor = Wall.new(self, 800, 1610, 1600, 20)
		@left_wall = Wall.new(self, -10, 800, 20, 1600)
		@right_wall = Wall.new(self, 1610, 870, 20, 1460)
		#END_HIGHLIGHT
		@sign = Gosu::Image.new('images/exit.png')
		@font = Gosu::Font.new(40)
		@font_small = Gosu::Font.new(18)
		@music = Gosu::Song.new('sounds/zanzibar.ogg')
		@music.play(true)
  end

  def draw
		@camera.view do
			(0..3).each do |row|
				(0..1).each do |column|
					@background.draw(799 * column, 529 * row, 0)
				end
			end
			@sign.draw(1450, 30, 2)
			@player.draw
			@boulders.each { |boulder| boulder.draw }
			@platforms.each { |platform| platform.draw }
		end
		if @game_over == false
			@seconds = (Gosu.milliseconds / 1000).to_i
			@font.draw("#{@seconds}", 10,20,3,1,1,0xff00ff00)
		else
			@font.draw("#{@win_time/1000}", 10, 20, 3, 1, 1, 0xff00ff00)
			# @font.draw("Game Over", 200, 300, 3,2,2,0xff00ff00)
			draw_credits
		end
		# @background.draw(0,0,0)
		# @background.draw(0,529,0) #one image doesn't fill window
		# @sign.draw(650, 30, 1)
  end

  def update
		camera.center_on(@player, 400, 200)
		unless @game_over
			10.times do
				@space.step(1.0/600) #update 600x/sec
			end
			if rand < BOULDER_FREQUENCY
				@boulders.push Boulder.new(self, 200 + rand(1200), -20)
				#boulder added off the top of the window, between 1/4 and 3/4 of the window width
			end
			@player.check_footing(@platforms + @boulders)
			if button_down?(Gosu::KbRight)
				@player.move_right
			elsif button_down?(Gosu::KbLeft)
				@player.move_left
			else
				@player.stand
			end
			@platforms.each do |platform|
				platform.move if platform.respond_to?(:move)
			end
			if @player.x > 820
        @game_over = true
        @win_time = Gosu.milliseconds
      end
		end

  end

	def make_platforms #creates all the platforms and returns array of platforms
		platforms = []
		# platforms.push Platform.new(self, 150, 700)
		# platforms.push Platform.new(self, 320, 650)
		# platforms.push Platform.new(self, 150, 500)
		# platforms.push Platform.new(self, 470, 550)
		# platforms.push MovingPlatform.new(self, 580, 650, 30, :vertical)
		# platforms.push MovingPlatform.new(self, 450, 230, 70, :horizontal)
		# platforms.push MovingPlatform.new(self, 190, 330, 50, :vertical)
		# platforms.push Platform.new(self, 320, 440)
		# platforms.push Platform.new(self, 600, 150)
		# platforms.push Platform.new(self, 700, 450)
		# platforms.push Platform.new(self, 580, 300)
		# platforms.push Platform.new(self, 750, 140)
		# platforms.push Platform.new(self, 700, 700)
		return platforms
	end


	def button_down(id)
		if id == Gosu::KbSpace
			@player.jump
		end
		if id == Gosu::KbQ
			close
		end
	end

	def draw_credits
		color = 0xff00ff00
		@font.draw('Game Over', 240, 150, 3, 2, 2, color)
		@font_small.draw('Images from the SpriteLib Collection', 100, 300, 3, 2, 2, color)
		@font_small.draw('by WidgetWorx under the terms of the', 100, 350, 3, 2, 2, color)
		@font_small.draw('Common Public License', 100, 400, 3, 2, 2, color)
		@font_small.draw('Music: Zanzibar, by Kevin MacLeod', 100, 500, 3, 2, 2, color)
		@font_small.draw('(incompetech.com)', 100, 550, 3, 2, 2, color)
		@font_small.draw('Licensed under', 100, 600, 3, 2, 2, color)
		@font_small.draw('Creative Commons: By Attribution 3.0', 100, 650, 3, 2, 2, color)
		@font_small.draw('http://creativecommons.org/licenses/by/3.0/', 100, 700, 3, 2, 2, color)
	end

end

window = Escape.new
window.show
