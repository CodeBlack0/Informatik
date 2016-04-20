#require_relative "aufgabe.rb"

class Aufgabenliste
  :liste

  def initialize()
    @liste = []
  end
  
  def size()
  	@liste.size
  end

  def <<(e)
    @liste << e if e.is_a? Aufgabe
  end

  def [](i)
    @liste[i]
  end

  def to_s()
    temp = []
    1.upto(@liste.size).each do |i|
      temp << "#{i}: #{@liste[i-1].to_s}"
    end
    temp.join("\n")
  end

  def offen()
    temp = Aufgabenliste.new()
    @liste.each do |e|
      temp << e if not e.erledigt?
    end
    temp.to_s
  end

  def erledigt()
    temp = Aufgabenliste.new()
    @liste.each do |e|
      temp << e if e.erledigt?
    end
    temp.to_s
  end
end