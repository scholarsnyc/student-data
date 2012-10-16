require 'spec_helper'

describe "Exam Model" do
  let(:exam) { Exam.new }
  it 'can be created' do
    exam.should_not be_nil
  end
end
