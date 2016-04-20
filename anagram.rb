file = "top10000en.txt"
file_contents = File.read("resources/documents/txt/#{file}").downcase.split(/\n/)

wort_gruppen = Hash.new{|h,k| h[k] = []}

file_contents.each do |wort|
  alpha_sort_wort = wort.chars.sort.join
  wort_gruppen[alpha_sort_wort] << wort
end

wort_gruppen.delete_if{|k,v| v.uniq.size <= 1}
output = []
output << "Anzahl: " + wort_gruppen.length.to_s + "\n"
wort_gruppen.each do |wort_gruppe, wort_liste|
  output << wort_gruppe + ": " + wort_liste.uniq.join(", ") + "\n"
end

puts output.join
puts output[0]
File.write("resources/documents/txt/anagrams_#{file}.txt", output.join)
