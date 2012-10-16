require 'spec_helper'

describe "Course Model" do
  let(:course) { Course.new }
  it 'can be created' do
    course.should_not be_nil
  end
end
