class Dog

  attr_reader :name
  attr_accessor :size

  def initialize(name = "unknown", size = 0)
    @name = name
    @size = size
  end

  def bark(n = 2)
    if (size < 10)
	    bark_sound = "yip"
    elsif (size >= 10 && size <= 20)
	    bark_sound = "arf"
    elsif (size > 20)
	    bark_sound = "woof"
	  end

    if(n != 1)
      puts  @name + ": #{bark_sound.capitalize}," + (" #{bark_sound},") * (n-2) + " #{bark_sound}!"
    else
      puts @name + ": #{bark_sound.capitalize}!"
    end
  end

  def info
    "name: #{@name}; size: #{@size}"
  end

  def grow_by(add)
    @size += add
  end
end
