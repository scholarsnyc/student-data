class Float
  def to_rounded_percent
    return self if self.zero?
    sprintf("%.2f", self * 100).to_f
  end

  def rounded
    return nil if self == 0
    sprintf("%.2f", self).to_f
  end
end

class NilClass
  def rounded
    nil
  end
  
  def -(*args)
    nil
  end
  
  def each(*args)
    nil
  end
end

def String
  def dearray
    self.gsub(/[\[\]"]/, '')
  end
end