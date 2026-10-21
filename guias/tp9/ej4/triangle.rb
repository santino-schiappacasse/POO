require_relative 'figure'

class Triangle < Figure
  def initialize(first_point, second_point, third_point)
    @first_point = first_point
    @second_point = second_point
    @third_point = third_point
  end

  def area
    semiperimiter = (first_side + second_side + third_side) / 2
    Math.sqrt(semiperimiter * (semiperimiter - first_side) * (semiperimiter - second_side) * (semiperimiter - third_side))
  end

  def perimeter = first_side + second_side + third_side

  def to_s
    "Triángulo [ #{@first_point} , #{@second_point} , #{@third_point} ]"
  end

  private

  def first_side = @first_point.distance(@second_point)

  def second_side = @second_point.distance(@third_point)

  def third_side = @third_point.distance(@first_point)

  protected attr_reader :first_point, :second_point, :third_point
end
