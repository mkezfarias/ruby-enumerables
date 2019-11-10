# frozen_string_literal: true

module Enumerable
  def my_each
    return to_enum unless block_given?

    if is_a? Array
      for i in self do
        yield(i)
      end
    elsif is_a? Hash
      for key, value in self do
        yield(key, value)
      end
    end
    self
  end

  def my_each_with_index
    return to_enum unless block_given?

    if is_a? Array
      i = 0
      while i < length
        yield(self[i], i)
         i += 1
      end
    elsif is_a? Hash
      j = 0
      while j < length
        yield([keys[j], values[j]], j)
         j += 1
      end
    end
    self
  end

  def my_select
    return to_enum unless block_given?

    if is_a? Array
      myarr = []
      my_each do |item|
        myarr.push(item) if yield(item)
      end
    elsif is_a? Hash
      myarr = {}
      my_each do |k, v|
        myarr[k] = v if yield(k, v)
      end
    end
    myarr
  end

  def my_all?(pattern = nil)
    return true unless block_given? || !pattern.nil?

    if pattern
      my_each do |item|
        return false unless item.is_a? pattern
      end
    elsif is_a? Array
      my_each do |item|
        return false unless yield(item)
      end
    elsif is_a? Hash
      my_each do |k, v|
        return false unless yield(k, v)
      end
    end
    true
  end

  def my_any?(pattern = nil)
    return false unless block_given? || !pattern.nil?

    if pattern
      my_each do |item|
        return true if item.is_a? pattern
      end
    elsif is_a? Array
      my_each do |item|
        return true if yield(item)
      end
    elsif is_a? Hash
      my_each do |k, v|
        return true if yield(k, v)
      end
    end
    false
  end

  def my_none?(pattern = nil)
    return true unless block_given? || !pattern.nil?

    if pattern
      my_each do |item|
        return true unless item.is_a? pattern
      end
    elsif is_a? Array
      my_each do |item|
        return true unless yield(item)
      end
    elsif is_a? Hash
      my_each do |k, v|
        return false if yield(k, v)
      end
    end
    false
  end

  def my_count(thing = nil)
    return length unless block_given? || !thing.nil?

    counter = 0
    if !thing.nil?
      my_each do |item|
        counter += 1 if item == thing
      end
    elsif is_a? Array
      my_each do |item|
        counter += 1 if yield(item)
      end
    elsif is_a? Hash
      my_each do |k, v|
        counter += 1 if yield(k,v)
      end
    end
    counter
  end

  def my_map
    return to_enum unless block_given?

    new_array = []
    if is_a? Array
      my_each do |k|
        new_array.push(yield(k))
      end
    elsif is_a? Hash
      my_each do |k, v|
        new_array.push(yield(k, v))
      end
    end
        new_array
  end

  def my_inject(*args)
    my_arr = to_a
    if block_given?
      my_arr = to_a
      result = args[0].nil? ? my_arr[0] : args[0]
      my_arr.shift if args[0].nil?
      my_arr.each do |number|
        result = yield(result, number)
      end
    elsif !block_given?
      my_arr = to_a
      if args[1].nil?
        symbol = args[0]
        result = my_arr[0]
        my_arr[1..-1].my_each do |i|
        result = result.send(symbol, i)
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
p [1, 2, 3].my_map(&double).my_map{ |num| num*2 }

#arrs = [a:3,b:3,c:3,d:4,f:5]
#arrs.my_each_with_index{|(x,a| puts "my #{x} and my #{a}"}