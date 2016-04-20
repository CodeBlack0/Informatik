class Circle
  :radius

  def initialize(radius = 1)
    @radius = radius
  end

  def area
    Math::PI * radius**2
  end

  def perimeter
    (Math::PI * radius) / 2
  end

  def radius
    @radius
  end

  def radius=(radius = @radius)
    @radius = radius
  end
end
