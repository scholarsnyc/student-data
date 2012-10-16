require 'spec_helper'

describe "Student Model" do
  let(:student) { Student.new }
  it 'can be created' do
    student.should_not be_nil
  end
end
