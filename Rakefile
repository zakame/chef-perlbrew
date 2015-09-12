require 'foodcritic'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

task default: [ 'style:chef', 'style:ruby', 'test:unit' ]

## ---------------------------------------------------------------------------------------------------------------------
namespace :style do
## ---------------------------------------------------------------------------------------------------------------------
  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new( :chef )
  
  desc 'Run Ruby style checks'
  RuboCop::RakeTask.new( :ruby ) do
    print_header( 'Rake - RuboCop: Running  style checks' )
  end
end

## ---------------------------------------------------------------------------------------------------------------------
namespace :test do
## ---------------------------------------------------------------------------------------------------------------------
  desc 'Run ChefSpec unit tests'
  RSpec::Core::RakeTask.new( :unit ) do |t|
    print_header( 'Running ChefSpec unit tests' )
    
    t.rspec_opts = '--pattern test/unit/**/*_spec.rb'
    t.verbose = false
  end
end

## ---------------------------------------------------------------------------------------------------------------------
def print_header( msg )
## ---------------------------------------------------------------------------------------------------------------------
  puts "\n"
  puts '## ' + ('-' * 77)
  puts "## #{msg}"
  puts '## ' + ('-' * 77)
end
private :print_header
