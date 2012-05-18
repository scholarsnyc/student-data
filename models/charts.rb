class Chart
  def self.probation(options = {})
    marking_period = options[:mp] || CURRENT_MARKING_PERIOD
    size = options[:size] || '460x310'
    
    title = "Probation Data: MP #{marking_period}"
    students = Student.all
    
    if options[:grade] 
      students = students.grade(options[:grade])
      title = title + " - Grade#{'s' if options[:grade].is_a? Array} #{options[:grade].to_s.gsub(/[\[\]]/,'')}"
    end
    
    if options[:cohort]
      students = students.cohort(options[:cohort])
      title = title + " - Cohort#{'s' if options[:cohort].is_a? Array} #{options[:cohort].to_s.gsub(/[\[\]]/,'')}"
    end
    
    GoogleChart::PieChart.new(size, title, false) do |chart|
      chart.data "Good Standing", students.good_standing(marking_period).count
      chart.data "Probation 1", students.probation_1(marking_period).count
      chart.data "Probation 2", students.probation_2(marking_period).count
      chart.data "Probation 2 Plus", students.failing(marking_period).count
      chart.show_labels = true
    end
  end
  
  def self.probation_bar(options = {})
    marking_period = options[:mp] || CURRENT_MARKING_PERIOD
    size = options[:size] || '460x310'
    width = size[0..2].to_i
    height = size[4..6].to_i
    
    title = "Probation by Grade: MP #{marking_period}"
    students = Student.all
    
    GoogleChart::BarChart.new(size, title, :vertical, true) do |chart|
      chart.data "Probation 2 Plus", Student.grades.map{|x| students.grade(x).failing(marking_period).count}, 'FF0000'
      chart.data "Probation 2", Student.grades.map{|x| students.grade(x).probation_2(marking_period).count}, 'FF9900'
      chart.data "Probation 1", Student.grades.map{|x| students.grade(x).probation_1(marking_period).count}, 'FFCC00'
      chart.width_spacing_options(:bar_spacing => height/100, :bar_width => width/10)
    end
  end

end