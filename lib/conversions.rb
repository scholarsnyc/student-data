module Conversions
  module Examinations
    SYMBOLS = [:ela, :math, :ela_predictive, :math_predictive, :ela_acuity, :math_acuity, :ela_psat, :math_psat]
    STRINGS = ["ELA", "Math", "ELA Predictive", "Math Predictive", "ELA Acuity", "Math Acuity", "PSAT Critical Reading", "PSAT Math"]
    NUMBERS = {
      :ela => 0,
      :math => 1,
      :ela_predictive => 2,
      :math_predictive => 3,
      :ela_acuity => 4,
      :math_acuity => 5,
      :ela_psat => 6,
      :math_psat => 7
    }
    
    def self.convert(term)
      return SYMBOLS[term] if term.is_a? Integer
      return NUMBERS[term] if NUMBERS.keys.include?(term)
      return SYMBOLS[STRINGS.index(term)] if STRINGS.include?(term)
      return :ela if term == "English"
      return :math if term == "Mathematics"
    end
    
    def self.adjust(score)
      score < 5 ? (score * 100/4.5).to_i : score.to_i
    end
  end
  
  module Courses     
    COURSES = {
      :ela => "English",
      :library => "Library",
      :math => "Mathematics",
      :media => "Media Arts",
      :music => "Music",
      :newspaper => "Newspaper",
      :gym => "Physical Education",
      :science => "Science",
      :socialstudies => "Social Studies",
      :spanish => "Spanish",
      :tech => "Technology",
      :art => "Visual Art"
    }
    
    def self.convert(term)
      return COURSES[term] if term.is_a? Symbol
      return COURSES.invert[term] if term.is_a? String
      return COURSES.keys[term] if term.is_a? Integer
    end
    
    def self.convert_to_sym(term)
      return term if COURSES.keys.include? term
      return COURSES.invert[term] if term.is_a? String
      raise ArgumentError, "Invalid course."
    end
    
    def self.convert_to_s(term)
      return term if COURSES.invert.keys.include? term
      return COURSES[term] if term.is_a? Symbol
      raise ArgumentError, "Invalid course."
    end
  end
end