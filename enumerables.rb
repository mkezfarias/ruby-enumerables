module Enumerable
  def my_each
    return to_enum unless block_given?
    arr_to_work = self
    if arr_to_work.is_a? Array
      for i in arr_to_work do
        yield(i)
      end       
    elsif arr_to_work.is_a? Hash
      for key,value in arr_to_work do
        yield(key,value)
      end  
    end
    self
  end

  def my_each_with_index
    return to_enum unless block_given?
    arr_to_work = self
    if arr_to_work.is_a? Array
      i = 0
      while i < arr_to_work.length do
        yield(arr_to_work[i], i)
          i = i+1
      end
    elsif arr_to_work.is_a? Hash
      j = 0
      while j < arr_to_work.length do
        yield([arr_to_work.keys[j], arr_to_work.values[j]], j)
          j += 1
      end
    end
    self
  end

  def my_select
    return to_enum unless block_given?
    arr_to_work = self
    if arr_to_work.is_a? Array
      myarr = []
      arr_to_work.my_each do |item|
        myarr.push(item) if yield(item)
      end
    elsif arr_to_work.is_a? Hash 
      myarr = {}
      arr_to_work.my_each do |k,v|
        myarr[k]=v if yield(k,v)
      end
    end
  myarr
  end

  def my_all?(pattern = nil)
    return true unless block_given? || !pattern.nil?
    arr_to_work = self
    if pattern
      arr_to_work.my_each do |item|
        return false unless item.is_a? pattern
      end
    elsif arr_to_work.is_a? Array
      arr_to_work.my_each do |item|
        return false unless yield(item)
      end 
    elsif arr_to_work.is_a? Hash
      arr_to_work.my_each do |k,v|
        return false unless yield(k,v)
      end
    end
    true
  end

  def my_any?(pattern=nil)
    return false unless block_given? || !pattern.nil?
    arr_to_work = self
    
    if pattern
      arr_to_work.my_each do |item|
        return arr_to_work unless !item.is_a? pattern
      end

    elsif arr_to_work.is_a? Array
      arr_to_work.my_each do |item|
        return true if yield(item)
      end 
    elsif arr_to_work.is_a? Hash
      arr_to_work.my_each do |k,v|
        return true if yield(k,v)
      end
    end
    false
  end

  def my_none?(pattern = nil)
  return true unless block_given? || !pattern.nil?
  arr_to_work = self
    if pattern
      arr_to_work.my_each do |item|
        return true unless item.is_a? pattern
      end
    elsif arr_to_work.is_a? Array
      arr_to_work.my_each do |item|
        return true unless yield(item)
      end 
    elsif arr_to_work.is_a? Hash
      arr_to_work.my_each do |k,v|
        return false if yield(k,v)
      end
    end
    false
  end

  def my_count(x = nil)
    return length unless block_given? || !x.nil?

    arr_to_work = self

    counter = 0
    if !x.nil? 
      arr_to_work.my_each do |item|
        if item == x
          counter +=1
        end
      end
    elsif arr_to_work.is_a? Array
      arr_to_work.my_each do |item|
        if yield(item)
          counter +=1
        end
      end
    elsif arr_to_work.is_a? Hash
      arr_to_work.my_each do |k,v|
        if yield(k,v)
          counter +=1
        end
      end
    end
    counter
  end

  def my_map
    return to_enum unless block_given?
    
    arr_to_work = self

    new_array = []
    if arr_to_work.is_a? Array
      arr_to_work.my_each do |k|
        new_array.push(yield(k))
      end
    elsif arr_to_work.is_a? Hash
      arr_to_work.my_each do |k,v|
        new_array.push(yield(k,v))
      end
    end
        new_array
  end

  def my_inject(*args)

    arr_to_work = self
    my_arr = arr_to_work.to_a
    if block_given?
      my_arr = arr_to_work.to_a
      result = args[0].nil? ? my_arr[0] : args[0]
      my_arr.shift if args[0].nil?
      my_arr.each do |number|
        result = yield(result,number)
      end
    elsif !block_given? 
      my_arr = arr_to_work.to_a
      if args[1].nil?
        symbol = args[0]
        result = my_arr[0]
        my_arr[1..-1].my_each do |i|
        result = result.send(symbol,i)
        end
      
      elsif !args[1].nil?
        symbol = args[1]
        result = args[0]
        my_arr.my_each do |i|
          result = result.send(symbol, i)
        end
      end
    end
    result
  end

end

def multiply_els(a)
  a.my_inject(:*)
end
p multiply_els([2,4,5])


double = Proc.new { |num| num*2 }
p [1, 2, 3].my_map(&double).my_each{ |num| num*2 }