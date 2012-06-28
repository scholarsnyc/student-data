require 'csv'

module RegentsCodes

	CODES = {
	 "SXRK" => ["LIVENVIR R", 16],
	 "SZRK" => ["LIVENVIR R", 16],
	 "FZPS" => ["SPANISH PROF", 30],
	 "MXZEE" => ["ALGEBRA REG JUN ACC", 13],
	 "SXZKE" => ["LIV ENV REG JUN ACC", 16],
	 "MXRE" => ["ALGEBRA REG", 13],
	 "EXRL" => ["ELA REG", 10],
	 "HXRA" => ["USHIST REG", 11],
	 "MXRG" => ["GEOMETRY REG", 14],
	 "SXR$" => ["PHSETPHYSR", 19],
	 "HXR$" => ["GLOBHISTRG", 12],
	 "MXRT" => ["ALG2 TRIG REG", 15],
	 "EXRLR" => ["ELA REG JAN", 10],
	 "FXTSE" => ["SPANISH LOTE", 31],
	 "SXRXE" => ["CHEMISTRY REG JUN", 18],
	 "SZRK" => ["LIV ENV REGENTS", 16],
	 "MZRE" => ["ALGEBRA REGENTS", 13],
	 "SXRU" => ["PHSET ES R", 19],
	 "SZRU" => ["PHSET ES R", 19],
	 "HXRUE" => ["USHIST REG JUN", 11],
	 "MXRGE" => ["GEOMETRY REG JUN", 14],
	 "SXRPE" => ["PHYSICS REG JUN", 19],
	 "SZRU" => ["PHY SET ES REGENTS", 19],
	 "HXRGE" => ["GLOB HIST REG JUN", 12],
	 "MXRTE" => ["TRIG REG JUN", 15],
	 "SXRX" => ["PHSETCHEMR", 19],
	 "FXRS" => ["SPAN REG", 31],
	 "MXRER" => ["ALGEBRA REG JAN", 13],
	 "MZRE" => ["Int Algebra Regents", 13],
	 "MXRTR" => ["TRIG REG JAN", 15],
	 "SXRKR" => ["LIVENVIR R JAN", 16],
	 "SXRUE" => ["PHSET ES REG JUN", 19],
	 "MXRGR" => ["GEOMETRY REG JAN", 14],
	 "SXRK" => ["Living Env Regents", 16],
	 "MXRE" => ["ALGEBRA REGENTS", 15],
	 "SXRU" => ["PHSET ES REG", 19],
	 "SXRU" => ["PHY SET ES REGENTS", 19],
	 "MXRG2" => ["GEOMETRY REG", 14],
	 "SXRK2" => ["LIVENVIR R", 16],
	 "SXRKE" => ["LIV ENVIR REG JUN", 16],
	 "SXRU" => ["EARTH SCIENCE REGENTS", 17],
	 "FXRN" => ["POLISH REGENTS", 40],
	 "MXRA" => ["MATH A REG", 50],
	 "FXRP" => ["POLISHREG", 40],
	 "FXTPE" => ["POLISH LOTE", 40],
	 "FXRF" => ["FRENCH REG", 41],
	 "MXRE" => ["INTEGRATED ALGEBRA REGENTS", 13],
	 "SXRXR" => ["CHEMISTRY R JAN", 18],
	 "SXRK" => ["LIV ENV REGENTS", 16],
	 "FZPT" => ["ITALIAN PROF", 42],
	 "FZPS" => ["SPAN PROFICIENCY", 30],
	 "MXRT" => ["ALG 2 TRIG REG", 15],
	 "MXRG" => ["REG GEOM", 14]
	}

end

class RegentsImporter
	attr_reader :data

	def initialize(spreadsheet)
			@data = Array.new
			CSV.open(spreadsheet).each {|row| @data << row}
			@data.delete_at(0)
			@data.map! {|row| RegentsExam.new(row)}
	end

	def process
		@data.each {|exam| exam.save}
	end
	
end

class RegentsExam
	attr_reader :osis, :year, :term, :code, :comment, :score

	def initialize(data)
		@osis = data[0]
		@year = data[4]
		@code = data[8]
		@comment = data[9]
		@score = data[10]
		@type = RegentsCodes::CODES[@code][1]
		if data[5] == 1
			@term = 3
		elsif data[5] == 2
			@term = 6
		else
			@term = data[5]
		end
	end
	
	def save
		return nil if Student.get(@osis).nil?
		exam = Exam.create(:score => @score, :type => @type, :student_id => @osis, :comment => @comment, :year => @year, :mp => @term)
	end
end