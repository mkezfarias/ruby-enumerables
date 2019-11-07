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

end

#----samples
t1 = [1,2,3,4,5]
t2 = {a:1, b:2, c:3, d:4}
t3 = ["do", "don't", "memee"]
t4 = {mi:"mama", me:"mima", mina:"moa", al:"together"}

#----tests
puts t1.my_select{|x| x <= 3}
puts t2.my_select{|x,y| y >= 3}  #{:c=>3, :d=>4}



=begin
#t1.my_each_with_index{|item,index| puts "#{item} and #{index} here"}
t2.my_each_with_index{|item,index| puts "#{item} and #{index} here"}
t2.my_each_with_index{|(key,value), i| puts "key is #{key} value is #{value} index is #{i}"}
t4.my_each_with_index{|(key,value), i| puts "#{key} and #{value} here and #{i} here"}
#t3.my_each_with_index{|(key,value), i| puts "#{key} and #{value} here and #{i} here"}

=end
