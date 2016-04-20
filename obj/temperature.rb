class Temperature
  attr_accessor :celsius

  def initialize(temp = 0)
    @celsius = temp
  end

  def fahrenheit=(temp)
    @celsius = ( temp - 32 ) / 1.8
  end

  def fahrenheit
    @celsius * 1.8 + 32
  end
end
