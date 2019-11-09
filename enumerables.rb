module Enumerable
  def my_each
    return self.to_enum unless block_given?
      
    if self.is_a? Array
      for i in self do
        yield(i)
      end       
    elsif self.is_a? Hash
      for key,value in self do
        yield(key,value)
      end  
    end
    self
  end

  def my_each_with_index
    return self.to_enum unless block_given?

    if self.is_a? Array
      i = 0
      while i < self.length do
        yield(self[i], i)
          i = i+1
      end
    elsif self.is_a? Hash
      j = 0
      while j < self.length do
        yield([self.keys[j], self.values[j]], j)
          j += 1
      end
    end
    self
  end

  def my_select
    return self.to_enum unless block_given?

    if self.is_a? Array
      myarr = []
      self.my_each do |item|
        myarr.push(item) if yield(item)
      end
    elsif self.is_a? Hash 
      myarr = {}
      self.my_each do |k,v|
        myarr[k]=v if yield(k,v)
      end
    end
  myarr
  end

  def my_all?(pattern=nil)
    return true unless block_given? || !pattern.nil?
    
    if pattern
      self.my_each do |item|
        return false unless item.is_a? pattern
      end
    elsif self.is_a? Array
      self.my_each do |item|
        return false unless yield(item)
      end 
    elsif self.is_a? Hash
      self.my_each do |k,v|
        return false unless yield(k,v)
      end
    end
    true
  end

  def my_any?(pattern=nil)
    return false unless block_given? || !pattern.nil?
    
    if pattern
      self.my_each do |item|
        return true unless !item.is_a? pattern
      end

    elsif self.is_a? Array
      self.my_each do |item|
        return true if yield(item)
      end 
    elsif self.is_a? Hash
      self.my_each do |k,v|
        return true if yield(k,v)
      end
    end
    false
  end

  def my_none?(pattern=nil)
  return true unless block_given? || !pattern.nil?
    
    if pattern
      self.my_each do |item|
        return true unless item.is_a? pattern
      end
    elsif self.is_a? Array
      self.my_each do |item|
        return true unless yield(item)
      end 
    elsif self.is_a? Hash
      self.my_each do |k,v|
        return false if yield(k,v)
      end
    end
    false
  end

  def my_count(x=nil)
    return self.length unless block_given? || !x.nil?

    counter = 0
    if !x.nil? 
      self.my_each do |item|
        if item == x
          counter +=1
        end
      end
    elsif self.is_a? Array
      self.my_each do |item|
        if yield(item)
          counter +=1
        end
      end
    elsif self.is_a? Hash
      self.my_each do |k,v|
        if yield(k,v)
          counter +=1
        end
      end
    end
    counter
  end

  def my_map
    return self.to_enum unless block_given?
    
    new_array = []
    if self.is_a? Array
      self.my_each do |k|
        new_array.push(yield(k))
      end
    elsif self.is_a? Hash
      self.my_each do |k,v|
        new_array.push(yield(k,v))
      end
    end
        new_array
  end

  def my_inject(*args)
    my_arr = self.to_a
    if block_given?
      my_arr = self.to_a
      result = args[0].nil? ? my_arr[0] : args[0]
      my_arr.shift if args[0].nil?
      my_arr.each do |number|
        result = yield(result,number)
      end
    elsif !block_given? 
      my_arr = self.to_a
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
p [1, 2, 3].my_map(&double).my_map{ |num| num*2 }


=begin
#----samples
t1 = [1,2,3,2,3]
t2 = {a:1, b:2, c:3, d:8}
t3 = ["do", "don't", "memee"]
t4 = {mi:"mama", me:"mima", mina:"moa", al:"together"}

=begin
#------- tests for inject
p t1.inject{|acc,val| acc + val}
p t1.my_inject{|acc,val| acc + val}
p t1.inject(20){|acc,val| acc + val}
p t1.my_inject(20){|acc,val| acc + val}
p (5..10).inject{|acc,val| acc + val}
p (5..10).my_inject{|acc,val| acc + val}
p t1.inject(:+)
p t1.my_inject(:+)
p t1.inject(2,:*)
p t1.my_inject(2,:*)

=begin
p t1.map {|x| x*2}
p t1.map {|z| z > 2}
p t1.map{|z| z == Numeric} 
p t2.map {|a,z| "my key is #{a} and value is #{z}"} 
p "----------------------"
p  t1.my_map {|x| x*2}
p  t1.my_map {|z| z > 2}
p  t1.my_map{|z| z == Numeric} 
p  t2.my_map {|a,z| "my key is #{a} and value is #{z}"} 
=begin
#------ tests for my_count
puts "#{t1.count} [1,2,3,2,5].count" 
puts "#{t1.count(2)} [1,2,3,2,5].count(2)"
puts "#{t1.count{|z| z > 2}} [1,2,3,2,5].count{|z| z > 2}"
puts "#{t1.count{|z| z == Numeric}} [1,2,3,2,5].count{|z| z == Numeric}"
puts "#{t2.count}} {a:1, b:2, c:3, d:8}.count"
puts "#{t2.count(2)}} {a:1, b:2, c:3, d:8}.count(2)"
puts "#{t2.count{|a,z| z > 2}}  {a:1, b:2, c:3, d:8}.count{|a,z| z > 2}"
puts "#{t2.count{|a,z| z == Numeric}} {a:1, b:2, c:3, d:8}.count{|a,z| z == Numeric}"
puts "----------------------"
puts "#{t1.my_count} [1,2,3,2,5].count"
puts "#{t1.my_count(2)} [1,2,3,2,5].count(2)"
puts "#{t1.my_count{|z| z > 2}} [1,2,3,2,5].count{|z| z > 2}"
puts "#{t1.my_count{|z| z == Numeric}} [1,2,3,2,5].count{|z| z == Numeric}"
puts "#{t2.my_count}} {a:1, b:2, c:3, d:8}.count"
puts "#{t2.my_count(2)}} {a:1, b:2, c:3, d:8}.count(2)"
puts "#{t2.my_count{|a,z| z > 2}}  {a:1, b:2, c:3, d:8}.count{|a,z| z > 2}"
puts "#{t2.my_count{|a,z| z == Numeric}} {a:1, b:2, c:3, d:8}.count{|a,z| z == Numeric}"
=begin
#----my_all? tests
puts t1.my_all?{|x| x < 0}
puts t2.my_all?{|x,y| y > 4}
puts t1.my_all?(Integer)
puts "----------------------"
puts t1.my_any?{|x| x < 0}
puts t2.my_any?{|x,y| y > 4}
puts t1.my_any?(Integer)
puts "----------------------"
puts t1.none?
puts t2.none?{|x,y| y < 4}
puts t1.none?(String)
puts "----------------------"
puts t1.none?
puts t2.none?{|x,y| y < 4}
puts t1.none?(String)
=begin
#----my_select tests
puts t1.my_select{|x| x <= 3}
puts t2.my_select{|x,y| y >= 3}  #{:c=>3, :d=>4}

#---- my_each_with_index tests
t1.my_each_with_index{|item,index| puts "#{item} and #{index} here"}
t2.my_each_with_index{|item,index| puts "#{item} and #{index} here"}
t2.my_each_with_index{|(key,value), i| puts "key is #{key} value is #{value} index is #{i}"}
t4.my_each_with_index{|(key,value), i| puts "#{key} and #{value} here and #{i} here"}
#t3.my_each_with_index{|(key,value), i| puts "#{key} and #{value} here and #{i} here"}

=end
