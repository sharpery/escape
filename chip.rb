class Chip

  RUN_IMPULSE = 600
  FLY_IMPULSE = 60
  JUMP_IMPULSE = 36000
  AIR_JUMP_IMPULSE = 1200
  SPEED_LIMIT = 400
  FRICTION = 0.7
  ELASTICITY = 0.2

  attr_accessor :off_ground

  def initialize(window, x, y)
    @window = window
    space = window.space
    @images = Gosu::Image.load_tiles('images/chip.png', 40, 65)
    @body = CP::Body.new(50, 100/0.0)
    @body.p = CP::Vec2.new(x, y)
    @body.v_limit = SPEED_LIMIT
    bounds = [
      CP::Vec2.new(-10, -32),
      CP::Vec2.new(-10, 32),
      CP::Vec2.new(10, 32),
      CP::Vec2.new(10, -32)
    ]
    shape = CP::Shape::Poly.new(@body, bounds, CP::Vec2.new(0, 0))
    shape.u = FRICTION
    shape.e = ELASTICITY
    space.add_body(@body)
    space.add_shape(shape)
    @action = :stand
    @image_index = 0
    @off_ground = true
  end

end
