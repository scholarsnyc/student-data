class LowestThirdAPI
  attr_reader :output
  
  def initialize
    @students = Student.middleschool

    @ela = Student.lowest_third_ela
    @math = Student.lowest_third_math 
    
    @grades = {
      6 => :six,
      7 => :seven,
      8 => :eight
    }
    
    @output = Hash.new
    
    generate(@ela, :ela)
    generate(@math, :math)
    
    return @output
  end
  
  private
  
  def generate(students, subject)
    @output[subject] = {
      :ids => students.map {|s| s.id },
      :count => students.count
    }
    
    @grades.each do |number, word|
      @output[subject][word] = {
        :lowestThirdCount => students.grade(number).count,
        :wholeGradeCount => @students.grade(number).count,
        :notInLowestThirdCount => @students.grade(number).count - students.grade(number).count,
        :lowestThirdAverage => students.grade(number).exams.state.ela.avg(:score),
        :wholeGradeAverage => @students.grade(number).exams.state.ela.avg(:score)
      }
    end
  end
end

class TrendLineAPI
  def initialize
    
  end
end