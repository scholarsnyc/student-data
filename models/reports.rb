require './lib/conversions'

class ComprehensiveReport
  include Conversions
  attr_reader :students, :mp, :subject, :coursework
  
  # Predicted Progress Based on Predictive: 2011 NYS to Predictive 2012.
  # Predicted Progress Based on Benchmark: 2011 NYS to Benchmark Average.
  
  def initialize(students, subject, options = {})
    unless students.is_a? DataMapper::Collection
      raise ArgumentError, 'You must provide a collection of students.'
    end
    @students = students
    @subject = Courses.convert_to_sym(subject)
    @options = options
    @mp = @options[:mp]
    @coursework = @students.records(options).subject(Courses.convert_to_s(@subject))
  end
  
  def cohort(c)
    raise ArgumentError unless @students.cohorts.include?(c)
    return ComprehensiveReport.new(@students.cohort(c), @subject, @options)
  end
  
  def exam_average(type, options = {})
    subject = options.delete(:subject) || @subject
    return nil unless [:ela, :math].include?(subject)
    exams = @students.exams(options).filter(:type => type, :subject => subject).avg(:score)
  end
  
  def predictive_exam(year)
    exam_average(:predictive, :year => year)
  end
  
  def state_exam(year)
    exam_average(:state, :year => year)
  end
  
  def average(type, options = {})
    # If a marking period was defined in the init method, then go with that.
    options[:mp] = @mp if @mp
    average = @coursework.all(options).avg(type)
    if average.zero?
      return nil
    else
      return average
    end
  end
  
  def compare_predictive_with_state(state_year, predictive_year)
    unless predictive_exam(predictive_year).nil? || state_exam(state_year).nil?
      predictive_exam(predictive_year) - state_exam(state_year)
    end
  end
  
  def compare_benchmark_with_state(year = Time.now.year - 1, options = {})
    return nil if state_exam(year).nil? || average(:exam).nil?
    average(:exam, options) - state_exam(year)
  end

  def compare_grades_with_state(year = Time.now.year - 1, options = {})
    return nil if state_exam(year).nil? || average(:score).nil?
    average(:score, options) - state_exam(year)
  end

  def students_on_probation(options = {})
    @coursework.all(options).probationary.students.uniq.count
  end
  
  def percent_on_probation(options = {})
    result = sprintf('%.2f', students_on_probation(options) * 1.0 / @students.count * 100).to_f
    result.zero? ? nil : result
  end
  
  def to_hash
    {  
      :examAverage => exam_average(:state).rounded,
      :benchmarkAverage => average(:exam).rounded,
      :predictiveAverage => predictive_exam(2012).rounded,
      :compareBenchmarkToState => compare_benchmark_with_state.rounded,
      :comparePredictiveToState => compare_predictive_with_state(2011, 2012).rounded,
      :benchmarkByMarkingPeriod => (1.upto(CURRENT_MARKING_PERIOD).to_a.map { |mp| 
        {:mp => mp, :score => average(:exam, :mp => mp).rounded}
        }.flatten ),
      :examAverageELA => exam_average(:state, :subject => :ela).rounded,
      :examAverageMath => exam_average(:state, :subject => :math).rounded,
    }
  end
  
  def to_json
    to_hash.to_json
  end
  
  def to_a
    to_hash.values
  end
  
  def to_table_row(group)
    rows = to_hash.map {|key, value| "<td class=\"#{key}\">#{value}</td>"}
    rows = ["<tr>", "<td>#{group}</td>", rows, "</tr>"].flatten.join()
  end
end

class LowestPerformers
  attr_reader :subject, :grade, :records, :students

  def initialize(grade, subject, cohort = :all, type = :score, mp = CURRENT_MARKING_PERIOD, count = 10)
    @subject = subject
    @grade = grade
    records = Record.all(:student => {:grade => grade}, :course => {:subject => subject}, :mp => mp, :order => [type.asc], type.not => nil)
    records = records.all(:student => {:cohort => cohort }) unless cohort == :all
    @records = records.first(count)
    @students = @records.students
  end

  def subject_to_class
    @subject.downcase.gsub(/ /, '')
  end

  def has_exam?
    subjects_with_exams = ["English", "Mathematics"]
    !!subjects_with_exams.include?(@subject)
  end
end

class GradeReport
  attr_reader :grade, :cohort, :marking_period, :ela_state, :math_state, :ela_predictive, :math_predictive, :ela_delta, :math_delta, :ela_grade_avg, :math_grade_avg, :ela_benchmark_avg, :math_benchmark_avg

  def self.middle_school(marking_period)
    [
      GradeReport.new(6, :A, marking_period),
      GradeReport.new(6, :B, marking_period),
      GradeReport.new(6, :C, marking_period),
      GradeReport.new(7, :A, marking_period),
      GradeReport.new(7, :B, marking_period),
      GradeReport.new(8, :A, marking_period),
      GradeReport.new(8, :B, marking_period)
    ]
  end
  
  def initialize(grade, cohort, marking_period = CURRENT_MARKING_PERIOD)
    
    @grade, @cohort, @marking_period  = grade, cohort, marking_period

    exams = Exam.all(:student => {:grade => grade, :cohort => cohort})
    records = Record.all(:mp => @marking_period, :student => {:grade => @grade, :cohort => cohort})

    @ela_state = Conversions::Examinations.adjust(exams.all(:type => 0).avg(:score))
    @math_state = Conversions::Examinations.adjust(exams.all(:type => 1).avg(:score))
    @ela_predictive = exams.all(:type => 2).avg(:score)
    @math_predictive = exams.all(:type => 3).avg(:score)
    @ela_delta = @ela_predictive - @ela_state
    @math_delta = @math_predictive - @math_state
    @ela_grade_avg = records.all(:course => {:subject => "English"}).avg(:score)
    @math_grade_avg = records.all(:course => {:subject => "Mathematics"}).avg(:score)
    @ela_benchmark_avg = records.all(:course => {:subject => "English"}).avg(:exam)
    @math_benchmark_avg = records.all(:course => {:subject => "Mathematics"}).avg(:exam)
  end

  def to_a
    return [@ela_state, @math_state, @ela_predictive, @math_predictive, @ela_delta, @math_delta, @ela_grade_avg, @math_grade_avg, @ela_benchmark_avg, @math_benchmark_avg]
  end
end

class ProbationReport
  attr_reader :grade, :marking_period, :total, :good_standing, :probation_1, :probation_2, :failing

  def self.whole_school(marking_period = CURRENT_MARKING_PERIOD)
    (6..12).map {|x| ProbationReport.new(x)}
  end

  def initialize(grade, marking_period = CURRENT_MARKING_PERIOD)
    @grade, @marking_period = grade, marking_period

    @grade == :all ? students = Student.all : students = Student.all(:grade => @grade)

    @total = students.count
    @good_standing = students.good_standing(@marking_period).count
    @probation_1 = students.probation_1(@marking_period).count
    @probation_2 = students.probation_2(@marking_period).count
    @failing =students.failing(@marking_period).count
  end

  def to_a
    [@good_standing, @probation_1, @probation_2, @failing]
  end

  def percent_to_a
    self.to_a.map {|x| sprintf("%.2f", x.to_f/@total * 100) + "%"}
  end

  def numbers_and_percents
    self.to_a.map {|x| [x, sprintf("%.2f", x.to_f/@total * 100) + "%"]}
  end

end

class GenderBreakdown
  attr_reader :breakdown

  def initialize(type = :state, grades = nil)
    grades = Student.grades if grades.nil?
    students = Student.all
    males = students.gender(:male)
    females = students.gender(:female)
    @breakdown = {}

    case type
    when :state
      ela, math = 0, 1
    when :predictive
      ela, math = 2, 3
    when :psat
      ela, math = 6, 7
    else
      raise "Invalid exam type"
    end

    grades.each do |grade|
      breakdown[grade] = {
        :ela => {
          :male => males.exams(:type => ela).avg(:score),
          :female => females.exams(:type => ela).avg(:score)
        },
        :math => {
          :male => males.exams(:type => math).avg(:score),
          :female => females.exams(:type => math).avg(:score)
        }
      }
    end
    return @breakdown
  end

  def grade(grade)
    return @breakdown[grade]
  end
end