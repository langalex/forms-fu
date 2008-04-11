require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'forms_fu_helper')

gem 'activesupport'
require 'activesupport'

describe FormsFuHelper do
  
  class TestClass; end
  
  before(:each) do
    @test = TestClass.new
  end
  
  it "should render a star if a field is required" do
    TestClass.stub!(:required_field?).with(:name).and_return(true)
    label_fu(@test, :name).should include('*')
  end
  
  it "should not render a star if a field is not required" do
    TestClass.stub!(:required_field?).with(:name).and_return(false)
    label_fu(@test, :name).should_not include('*')
  end
end