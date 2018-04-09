require './lib/violations'
require 'pry'

violations = Violations.load('./data/violations.csv')

keymap = {
  violation_id: 'Violation ID:',
  inspection_id: 'Inspetion ID:',
  violation_category: 'Category:',
  violation_date: 'Date Opened:',
  violation_date_closed: 'Date Closed:',
  violation_type: 'Type:'
}

longest = keymap.values.map(&:length).max

keymap.transform_values! do |value|
  value.ljust(longest)
end

puts "Number of violation: #{violations.length}\n\n"

puts 'Earliest Violation:'

earliest = violations.earliest
earliest.each_key do |key|
  puts "\t#{keymap[key]}\t#{earliest[key]}" if earliest[key]
end

puts "\nLatest Violation By Type:"
latest = violations.latest_by_type
padding = nil
length = nil

latest.each do |type, violation|
  puts "\t#{type}:"
  violation.each_key do |key|
    next if key == :violation_type
    padding ||= "\t\t#{keymap[key]}".length
    out = "\t\t#{keymap[key]}\t#{violation[key]}" if violation[key]
    puts out
    length ||= out.length if key == :violation_date_closed
  end
  print "\n#{' '*padding}"
  print '-'*(length+1)
  puts "\n\n"
end
