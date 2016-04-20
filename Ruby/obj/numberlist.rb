class NumberList

  def initialize(array = [])
    @data = array
  end 

  def to_s
    @data.join(' ')
  end
  
  def to_a
    @data
  end

  def populate(i = 0)
    @data = []
    (0 .. i).each do |n|
      @data << rand(100)
    end
  end

  def sort()
    NumberList.new(@data.clone.sort)
  end
  
  def selection_sort()
    array = @data.clone
    n = array.size - 1
    n.times do |i|
      smallest = i
      (i + 1).upto(n) do |j|
        smallest = j if array[j] < array[smallest]
      end
      array[i], array[smallest] = array[smallest], array[i] if smallest != i
    end
    NumberList.new(array)
  end

  def insertion_sort()
    array = @data.clone
    (1..array.length-1).each do |i|
      k = array.delete_at(i)
      insertion_index = i
      insertion_index -= 1 while insertion_index > 0 && k < array[insertion_index -1]
      array.insert(insertion_index, k)
    end
    NumberList.new(array)
  end

  def bubble_sort()
    bottle = @data.clone
    loop do
      switch = false
      0.upto(bottle.size - 2).each do |i|
        if bottle[i] > bottle[i+1]
          bottle[i+1], bottle[i] = bottle[i], bottle[i+1] 
          switch = true
        end
      end
      break unless switch
    end
    NumberList.new(bottle)
  end

  def quick_sort()
    return @data if @data.length <= 1
    unsorted = @data.clone
    bigger = []
    smaller = []
    pivot_index = rand(unsorted.length)
    pivot = unsorted.delete_at(pivot_index)

    unsorted.each do |num|
      bigger << num if num >= pivot
      smaller << num if num < pivot
    end
    sorted = NumberList.new(smaller).quick_sort().to_a + [pivot] + NumberList.new(bigger).quick_sort().to_a
    NumberList.new(sorted)
  end

  def inplace_selection_sort()
    pool = @data.clone
    pool.length.times do |i|
      to_move = 0
      (pool.length-i).times do |j|
        to_move = j if pool[to_move] > pool[j]
      end
      pool << pool.delete_at(to_move)
    end
    NumberList.new(pool)
  end

  def inplace_dafuq_sort()
    pool = @data.clone
    pool.length.times do |i|
      to_move = 0
      (pool.length-i).times do |j|
        tmp = pool[j..-1]
        tmp.length.times do |k|
          to_move = k if tmp[k] > pool[0]
        end
      end
      pool << pool.delete_at(to_move)
    end
    NumberList.new(pool)
  end

  def inplace_insertion_sort()
    pool = @data.clone
    pool.length.times do |i|
      to_move = 0
      pool[0..i].each_with_index do |k,j|
        if k > pool[-1]
          to_move = j-1
          break
        end 
      end
      move = pool.delete_at(-1)
      puts "#{move}[#{to_move}]"
      pool.insert(to_move,move)
    end
    NumberList.new(pool)
  end
end


