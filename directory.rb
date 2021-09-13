#! usr/bin/env ruby
# frozen_string_literal: true

students = [
  'Dr. Hannibal Lecter',
  'Darth Vader',
  'Nurse Ratched',
  'Michael Corleone',
  'Alex DeLarge',
  'The Wicked Witch of the West',
  'Terminator',
  'Freddy Krueger',
  'The Joker',
  'Joffrey Baratheon',
  'Norman Bates'
]

def print_header
  puts 'The students of Villains Academy'
  puts '-------------'
end

def print(students)
  students.each { |student| puts student }
end

def print_footer(students)
  puts "Overall, we have #{students.count} great students"
end

print_header
print(students)
print_footer(students)
