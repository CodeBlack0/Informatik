def rand_array_sort(arr)
  new = []
  while arr.length > 0
    r = rand(arr.length)
    new << arr[r]    
    arr.delete_at(r)
  end
  new
end

test = [1,5,4,3,6,7,8,0,2,9]
puts test.to_s
puts rand_array_sort(test).to_s
