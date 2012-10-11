REGENTS = CSV.read('./data/regents_jun_2012_post_taiwo.csv')

def import_regents
  REGENTS.each do |r|
    student = r[0].to_i

    unless r[2].empty?
      Exam.create(:student_id => student,
                  :type => 10,
                  :score => r[2].to_i,
                  :comment => "English Regents (June, 2012)",
                  :mp => 6,
                  :year => 2012)
    end

    unless r[3].empty?
      Exam.create(:student_id => student,
                  :type => 12,
                  :score => r[3].to_i,
                  :comment => "Global History Regents (June, 2012)",
                  :mp => 6,
                  :year => 2012)
    end

    unless r[4].empty?
      Exam.create(:student_id => student,
                  :type => 11,
                  :score => r[4].to_i,
                  :comment => "US History Regents (June, 2012)",
                  :mp => 6,
                  :year => 2012)
    end

    unless r[5].empty?
      Exam.create(:student_id => student,
                  :type => 13,
                  :score => r[5].to_i,
                  :comment => "Integrated Algebra (June, 2012)",
                  :mp => 6,
                  :year => 2012)
    end

    unless r[6].empty?
      Exam.create(:student_id => student,
                  :type => 14,
                  :score => r[6].to_i,
                  :comment => "Geometry (June, 2012)",
                  :mp => 6,
                  :year => 2012)
    end

    unless r[7].empty?
      Exam.create(:student_id => student,
                  :type => 15,
                  :score => r[7].to_i,
                  :comment => "Trigonometry (June, 2012)",
                  :mp => 6,
                  :year => 2012)
    end

    unless r[8].empty?
      Exam.create(:student_id => student,
                  :type => 16,
                  :score => r[8].to_i,
                  :comment => "Living Environment (June, 2012)",
                  :mp => 6,
                  :year => 2012)
    end
    
    unless r[9].empty?
      Exam.create(:student_id => student,
                  :type => 17,
                  :score => r[9].to_i,
                  :comment => "Earth Science Regents (June, 2012)",
                  :mp => 6,
                  :year => 2012)
    end

    unless r[10].empty?
      Exam.create(:student_id => student,
                  :type => 18,
                  :score => r[10].to_i,
                  :comment => "Chemistry Regents (June, 2012)",
                  :mp => 6,
                  :year => 2012)
    end

    unless r[11].empty?
      Exam.create(:student_id => student,
                  :type => 32,
                  :score => r[11].to_i,
                  :comment => "Foreign Language Profiency (June, 2012)",
                  :mp => 6,
                  :year => 2012)
    end
  end
end
