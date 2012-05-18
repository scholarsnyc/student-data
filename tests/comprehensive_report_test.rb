module CompTest
  def self.test_exam_results
    c = ComprehensiveReport.new Student.grade(7), :math
    ct = c.exam_average
  end
end