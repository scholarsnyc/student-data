require 'csv'
require 'json'

module CourseChanges
  changes_cache = './json/course_changes.json'

  if File.exists? changes_cache
    @converter = JSON.parse File.read changes_cache
  else
    @converter = Hash.new
    changes = CSV.open(Dir.glob("./data/changes*").first, 'rb').to_a
    changes.each do |r|
      begin
        next if r[0].nil? || r[2].nil? || r[0] == r[2]
        @converter[r[0]] = r[2]
      rescue
        next
      end
    end
    File.open(changes_cache, "w") { |io| 
        io.puts @converter.to_json
      }
  end

  def CourseChanges.update_course(course)
    if @converter[course]
      return @converter[course]
    else
      return course
    end
  end

  def CourseChanges.has_update?(course)
    @converter[course] ? true : false
  end
end
