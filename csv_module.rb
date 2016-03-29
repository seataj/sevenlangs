module ActsAsCsv
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def acts_as_csv
      include InstanceMethods
    end
  end

  module InstanceMethods
    def read
      @csv_contents = []
      filename = self.class.to_s.downcase + '.txt'
      file = File.new(filename)
      @headers = file.gets.chomp.split(', ')

      file.each do |row|
        @csv_contents << row.chomp.split(', ')
      end
    end

    def each(&block)
      @csv_contents.each do |row|
        #r = CsvRow.new(@headers, row)
        #block.call r
        block.call CsvRow.new(@headers, row)
      end
    end

    attr_accessor :headers, :csv_contents
    def initialize
      read
    end
  end
end

class CsvRow
  def method_missing(methId)
    header = methId.id2name
    @values[header]
  end

  attr_accessor :values
  def initialize(headers=[], contents=[])
    @values={}
    headers.each_with_index {|header,index| @values[header] = contents[index]}
  end
end

class RubyCsv
  include ActsAsCsv
  acts_as_csv
end

m = RubyCsv.new
puts m.headers.inspect
puts m.csv_contents.inspect
puts

puts "Testing CsvRow"
r = CsvRow.new(m.headers,m.csv_contents[1])
puts r.one
puts

puts "Day 3 Self-Study"
puts m.each {|row| puts "one [" + row.one + "]"}
puts
