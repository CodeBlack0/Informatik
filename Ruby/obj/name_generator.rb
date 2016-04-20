class NameGenerator
  :attributes
  :animals

  def initialize (attributes=["Dead"], animals=["Donkey"])
    @attributes = attributes
    @animals = animals
  end

  def random
    @attributes.sample + " " + @animals.sample
  end
end

attributes_sample = ["Sitting", "Big", "Little", "Flying"]
animals_sample    = ["Bull", "Horse", "Eagle", "Fox"]
