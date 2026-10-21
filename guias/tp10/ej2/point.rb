class Point
  def initialize(x, y)
    @x = x
    @y = y
  end

  def to_s = "{#{@x}, #{@y}}"

  def distance(point)
    ((point.x - @x)**2 + (point.y - @y)**2)**0.5
  end

  attr_reader :x, :y
end
