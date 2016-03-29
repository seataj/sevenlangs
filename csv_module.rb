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
        row_a = row.chomp.split(', ')
        @csv_contents << row_a
        @rows << CsvRow.new(@headers, row_a)
      end
    end

    def each(&block)
      @rows.each {|row| block.call row}
    end
    
    attr_accessor :headers, :csv_contents
    def initialize
      @rows = []
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

puts "Day 3 Self-Study"
m.each {|row| puts row.one}
puts
m.each {|row| puts row.two}
