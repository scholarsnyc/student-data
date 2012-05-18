require 'csv'

# This will take columns of PSAT data and flatten it into individual records that can be sucked in by the "import_exams" method of DataImport.
# Eventually, I should probably just roll it in. That said, the DataImport feature is so terrible, that it may not even be worth it.

psat = CSV.read(ARGV[0])
output = CSV.open("exams-psat-#{Time.now.strftime('%Y-%m-%d-%N')}.csv", "w")

psat.each do |row|
	student_id = row[2]

	output << [student_id, row[3].to_i * 10, 6, "PSAT: Critical Reading 2010", 3, 2010] unless row[3].nil?
	output << [student_id, row[4].to_i * 10, 6, "PSAT: Critical Reading 2011", 3, 2010] unless row[4].nil?
	output << [student_id, row[5].to_i * 10, 7, "PSAT: Mathematics 2010", 3, 2010] unless row[5].nil?
	output << [student_id, row[6].to_i * 10, 7, "PSAT: Mathematics 2011", 3, 2010] unless row[6].nil?
end