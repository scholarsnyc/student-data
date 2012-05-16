class Grade
  attr_reader :students, :cohorts, :lowest_third_ela, :lowest_third_math
  def initialize(grade)
    @grade = grade
    @students = Student.all(:grade => grade)
    @lowest_third_ela = @students.lowest_third_ela
    @lowest_third_math = @students.lowest_third_math
    @not_lowest_third_ela = @students - @lowest_third_ela
    @not_lowest_third_math = @students - @lowest_third_math
    @cohorts = @students.cohorts.map {|c| c.to_sym }
  end
  
  def cohort(c)
    raise ArgumentError unless @cohorts.include?(c)
    @students.cohort(c)
  end
  
  def to_comprehensive_report(subject, options = {})
    output = {
      :grade => @grade,
      :subject => subject,
      :wholeGrade => @students.to_comprehensive_report(subject, options).to_hash,
      :lowestThirdELA => @lowest_third_ela.to_comprehensive_report(subject, options).to_hash,
      :lowestThirdMath => @lowest_third_math.to_comprehensive_report(subject, options).to_hash,
      :cohort => {}
    }
    @cohorts.each do |c|
      output[:cohort][c] = {
        :wholeGrade => @students.cohort(c).to_comprehensive_report(subject, options).to_hash,
        :lowestThirdELA => @lowest_third_ela.cohort(c).to_comprehensive_report(subject, options).to_hash,
        :lowestThirdMath => @lowest_third_math.cohort(c).to_comprehensive_report(subject, options).to_hash
      }
    end
    output
  end
end

class Grades
  include Enumerable
  attr_reader :grades
  def initialize(*grades)
    @grades = grades.to_a.map {|g| Grade.new(g)}
  end
  
  def to_comprehensive_report(subject, options = {})
    grades = @grades.map {|g| g.to_comprehensive_report(subject, options)}
  end
end