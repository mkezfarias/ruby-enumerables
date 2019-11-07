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
end