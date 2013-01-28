require 'csv'

module Reports
  
  class MiddleSchoolExamReport
    attr_reader :grade, :cohort, :ela_exams, :math_exams, :ela_predictives, :math_predictives, :ela_benchmarks, :math_benchmarks, :ela_exams_last_year, :math_exams_last_year, :ela_change, :math_change  
    
    def initialize(grade, cohort, mp = 6, year = CURRENT_YEAR)
      @grade = grade
      @cohort = cohort
      @students = Student.all(previous_grade: @grade, previous_cohort: @cohort)
      @exams = @students.exams(type: [0,1,2,3], year: 2012)
      @exams_last_year = @students.exams(type: [0,1], year: 2011)
      @ela_exams = @exams.all(type: 0).avg(:score).rounded
      @math_exams = @exams.all(type: 1).avg(:score).rounded
      @ela_exams_last_year = @exams_last_year.all(type: 0).avg(:score).rounded
      @math_exams_last_year = @exams_last_year.all(type: 1).avg(:score).rounded
      @ela_change = (@ela_exams - @ela_exams_last_year).rounded
      @math_change = (@math_exams - @math_exams_last_year).rounded
      @ela_predictives = @exams.all(type: 2).avg(:score).rounded
      @math_predictives = @exams.all(type: 3).avg(:score).rounded
      @ela_benchmarks = @students.courses(subject: "English").records(mp: mp, year: year).avg(:exam).rounded
      @math_benchmarks = @students.courses(subject: "Mathematics").records(mp: mp, year: year).avg(:exam).rounded
    end
    
    def to_a
      [
        @grade,
        @cohort,
        @ela_exams,
        @ela_exams_last_year,
        @ela_change,
        @ela_predictives,
        @ela_benchmarks,
        @math_exams,
        @math_exams_last_year,
        @math_change,
        @math_predictives,
        @math_benchmarks
      ]
    end
    
    def to_csv
      to_a.join(",")
    end
      
  end
  
  class MiddleSchoolExamCollection
    include Enumerable
  
    def initialize(mp = 6, year = CURRENT_YEAR)
      @report = [[6,:A],[6,:B],[6,:C],[7,:A],[7,:B],[8,:A],[8,:B]].map do |g|
        MiddleSchoolExamReport.new(g[0], g[1], mp, year)
      end
    end
    
    def each
      @report.each { |i| yield i }
    end
    
    def to_csv
      @report.map {|r| r.to_csv}.join("\n")
    end
  
  end

	class BenchmarkBreakdown
	
		def initialize(year = CURRENT_YEAR - 1)
			
		end
	
	end
  
end
