class Encrypt
  :abc
  :abc2
  
  def initialize()
    @abc = "abcdefghijklmnopqrstuvwxyz"
    @abc2 = @abc*2
  end

  def rot13(plain)
    plain.tr("a-z","n-za-m")
  end

  def rot_en(plain, key)
  	key = key[0] if key.length > 1
	plain.tr("a-z",@abc2[@abc.index(key),25])
  end

  def rot_de_brute(cypher)
  	plain_possiblities = []
    ("a" .. "z").each do |key|
	  plain_possiblities << cypher.tr(@abc2[@abc.index(key),25],"a-z")
    end
  	plain_possiblities
  end

  def vigenere_en(plain, key)
	full_counts = plain.length / key.length
	half_counts = plain.length % key.length
	strip = ""
	full_counts.times do
		strip += key
	end
	strip += key[0,half_counts]

	cypher = ""
	(1 .. plain.length).each do |pos|
		index = @abc.index(strip[pos - 1])
		cypher_abc = @abc2[index,25]
		cypher[pos - 1] = plain[pos - 1].tr("a-z",cypher_abc)
	end
	cypher
  end

  def vigenere_de(cypher, key)
	full_counts = cypher.length / key.length
	half_counts = cypher.length % key.length
	strip = ""
	full_counts.times do
		strip += key
	end
	strip += key[0,half_counts]

	plain = ""
	(1 .. cypher.length).each do |pos|
		index = @abc.index(strip[pos - 1])
		plain_abc = @abc2[index,25]
		plain[pos - 1] = cypher[pos - 1].tr(plain_abc,"a-z")
	end
	plain
  end

  def rsa_en_alphagen(e, n)
    cyphercodes = []
    alpha = {}
	(0 .. n-1).each do |num|
		cyphercodes << (num**e%n)
	end

	if cyphercodes.uniq.length != cyphercodes.length
		return nil
	end
	cyphercodes
  end

  def rsa_end_alphagen(e, n, d)
	cyphercodes = []
	valid = true
	(0 .. n-1).each do |num|
		en = (num**e%n)
		dn = (en**d%n)
		if dn != num
			valid = false
		end
		cyphercodes << en
	end
	return nil if not valid or cyphercodes.uniq.length != cyphercodes.length
    cyphercodes
  end
end