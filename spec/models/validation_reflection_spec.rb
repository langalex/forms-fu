require File.join(File.dirname(__FILE__), '..', 'helper')
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'validation_reflection')

ActiveRecord::Base.connection.execute 'DROP TABLE test_users' rescue nil
ActiveRecord::Base.connection.execute 'CREATE TABLE test_users (id int(4), first_name varchar(255), last_name varchar(255), type varchar(255))'

class TestUser < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :conditional_field, :if => lambda{|x| false}
  validates_presence_of :on_update_field, :on => :update
  validates_acceptance_of :terms
  validates_inclusion_of :status, :in => ['new', 'old']
  validates_inclusion_of :optional_status, :in => ['new', 'old', '']
  validates_inclusion_of :optional_status_2, :in => ['new', 'old'], :allow_nil => true
end

class TestPremiumUser < TestUser
  validates_presence_of :name
end

describe TestUser, 'required_field' do
  
  it "should require a field with validates_presence_of" do
    TestUser.should be_required_field(:name)
  end
  
  it "should require a field with validates_acceptance_of" do
    TestUser.should be_required_field(:terms)
  end
  
  it "should require a field with validates_inclustion_of" do
    TestUser.should be_required_field(:status)
  end
  
  it "should not require a field with validates_inclusion_of where blank is allowed" do
    TestUser.should_not be_required_field(:optional_status)
  end
  
  it "should not require a field with validates_inclusion_of where nil is allowed" do
    TestUser.should_not be_required_field(:optional_status_2)
  end
  
  it "should not require a field with an :if option" do
    TestUser.should_not be_required_field(:conditional_field)
  end
  
  it "should not require a field with an :on option not set to :create" do
    TestUser.should_not be_required_field(:on_update_field)
  end
  
  it "should work with single table inheritance" do
    TestPremiumUser.should be_required_field(:name)
  end
end

