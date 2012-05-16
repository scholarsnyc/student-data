class String
	def to_class
	  return 'not-english' if self.downcase == "spanish"
		self.gsub(/ /,'').downcase
	end
end

class Float
	def to_percent
    return self if self.zero?
		sprintf("%.2f", self * 100).to_f
	end
  def rounded
    return nil if self == 0
    sprintf("%.2f", self).to_f
  end
end

class Array
  def difference
    self.each {|i| return nil if i.nil? || i.to_i == 0}
    self.map! {|i| i.to_i}
    return self[0] - self[1]
  end
end

class NilClass
  def round
    nil
  end
  
  def rounded
    nil
  end
end