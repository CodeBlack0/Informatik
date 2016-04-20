require_relative "obj/aufgabe"
require_relative "obj/aufgabenliste"

aufgabe1 = Aufgabe.new("Aufgabe 1")
aufgabe2 = Aufgabe.new("Aufgabe 2")
aufgabe2.erledigt!
aufgabe3 = Aufgabe.new("Aufgabe 3")
aufgabe3.erledigt!
aufgabe4 = Aufgabe.new("Aufgabe 4")
aufgabe5 = Aufgabe.new("Aufgabe 5")

liste = Aufgabenliste.new
liste << aufgabe1
liste << aufgabe2
liste << aufgabe3
liste << aufgabe4
liste << aufgabe5

puts liste.to_s
puts 
puts liste.erledigt()
puts 
puts liste.offen()