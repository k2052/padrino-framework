BACON_SETUP = (<<-TEST).gsub(/^ {10}/, '') unless defined?(BACON_SETUP)
class Bacon::Context
  include Rack::Test::Methods
end

def app
  ##
  # You can handle all padrino applications using instead:
  #   Padrino.application
  CLASS_NAME.tap { |app|  }
end
TEST

BACON_CONTROLLER_TEST = (<<-TEST).gsub(/^ {10}/, '') unless defined?(BACON_CONTROLLER_TEST)
require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

describe "!NAME!Controller" do
  it 'returns text at root' do
    get "/"
    last_response.body.should == "some text"
  end
end
TEST

BACON_RAKE = (<<-TEST).gsub(/^ {10}/, '') unless defined?(BACON_RAKE)
require 'rake/testtask'

test_tasks = Dir['test/*/'].map { |d| File.basename(d) }

test_tasks.each do |folder|
  Rake::TestTask.new("test:\#{folder}") do |test|
    test.pattern = "test/\#{folder}/**/*_test.rb"
    test.verbose = true
  end
end

desc "Run application test suite"
task 'test' => test_tasks.map { |f| "test:\#{f}" }
TEST

BACON_MODEL_TEST = (<<-TEST).gsub(/^ {10}/, '') unless defined?(BACON_MODEL_TEST)
require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

describe "!NAME! Model" do
  it 'can be created' do
    @!DNAME! = !NAME!.new
    @!DNAME!.should.not.be.nil
  end
end
TEST

# Setup the testing configuration helper and dependencies
def setup_test
  require_dependencies 'rack-test', :require => 'rack/test', :group => 'test'
  require_dependencies 'bacon', :group => 'test'
  insert_test_suite_setup BACON_SETUP, :path => 'test/test_config.rb'
  create_file destination_root("test/test.rake"), BACON_RAKE
end

# Generates a controller test given the controllers name
def generate_controller_test(name)
  bacon_contents       = BACON_CONTROLLER_TEST.gsub(/!NAME!/, name.to_s.camelize)
  controller_test_path = File.join('test',options[:app],'controllers',"#{name.to_s.underscore}_controller_test.rb")
  create_file destination_root(controller_test_path), bacon_contents, :skip => true
end

def generate_model_test(name)
  bacon_contents  = BACON_MODEL_TEST.gsub(/!NAME!/, name.to_s.camelize).gsub(/!DNAME!/, name.to_s.underscore)
  model_test_path = File.join('test',options[:app],'models',"#{name.to_s.underscore}_test.rb")
  create_file destination_root(model_test_path), bacon_contents, :skip => true
end
