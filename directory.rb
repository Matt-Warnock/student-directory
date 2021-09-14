#! usr/bin/env ruby
# frozen_string_literal: true

require 'csv'

MENU = [
  '1. Input the students',
  '2. Show all students',
  '3. Show students by cohort',
  '4. Save students list',
  '4. Load Student list',
  '9. Exit'
].freeze

ACTIONS = [
  -> { input_students },
  -> { show_students },
  -> { print_students_list(only_cohort_group) },
  -> { menu_save },
  -> { menu_load }
].freeze

KEY_TO_REGEX = {
  cohort: /(Jan|Febr)uary|March|April|May|June|July|August|(Septem|Octo|Novem|Decem)ber/i,
  favorite_animal: /\w+/i,
  filename: /\w+/i,
  height: /\d+/i
}.freeze

@students = []
@input = $stdin

def input_students
  puts "Please enter the name of the student: \n(To finish, hit return twice)"

  name = @input.gets.chomp
  collect_students(name)
end

def collect_students(name)
  until name.empty?
    info_array = collect_additional_info.prepend(name)

    store_student(info_array)
    students_so_far(@students.count)
    name = @input.gets.chomp
  end
end

def collect_additional_info
  prompts = %w[cohort favorite_animal height]

  prompts.map do |prompt|
    puts "Enter student's #{prompt.sub('_', ' ')}: "

    collect_vaild_input(prompt.to_sym)
  end
end

def store_student(info_array)
  name, cohort, favorite_animal, height = info_array

  @students << {
    name: name, cohort: cohort.downcase.to_sym, favorite_animal: favorite_animal, height: height
  }
end

def collect_vaild_input(key)
  loop do
    user_input = @input.gets.chomp
    break user_input if user_input.match(KEY_TO_REGEX[key])

    puts 'invalid entry'
  end
end

def students_so_far(student_count)
  plural = pluralize(student_count)

  puts "Now we have #{student_count} student#{plural}"
end

def print_header
  title = 'The students of Villains Academy'

  puts title
  puts '-------------'.center(title.length)
end

def print_students_list(students)
  index = 0
  until students.length == index
    puts "#{index + 1}. #{students[index][:name]} (#{students[index][:cohort]} cohort)"
    index += 1
  end
end

def only_cohort_group
  puts 'Choose cohort: '
  user_choice = collect_vaild_input(:cohort)

  @students.filter { |student| student[:cohort].to_s == user_choice }
end

def print_footer(student_count)
  plural = pluralize(student_count)
  puts "Overall, we have #{student_count} great student#{plural}"
end

def pluralize(student_count)
  student_count > 1 ? 's' : ''
end

def interactive_menu
  loop do
    puts MENU
    process(@input.gets.chomp)
  end
end

def process(user_choice)
  exit if user_choice == '9'

  if user_choice.match?(/^[1-5]$/)
    ACTIONS[user_choice.to_i - 1].call
  else
    puts 'Invaild selection, try again: '
  end
end

def show_students
  print_header
  print_students_list(@students)
  print_footer(@students.count)
end

def save_students(filename = 'students.csv')
  File.open(filename, 'w') do |file|
    csv = CSV.new(file)

    @students.each do |student|
      csv << student.values
    end
  end
end

def load_student(filename = 'students.csv')
  File.open(filename, 'r') do |file|
    csv = CSV.new(file)

    csv.read.each do |line|
      store_student(line)
    end
  end
end

def menu_save
  save_students(ask_for_file)
  puts 'Students file save completed'
end

def menu_load
  filename = ask_for_file
  manage_file(filename)
  load_student(filename)
  puts 'Students file loaded'
end

def try_load_file
  filename = ARGV.first

  return load_student if filename.nil?

  manage_file(filename)
end

def manage_file(filename)
  if File.exist?(filename)
    load_student(filename)
    puts "Loaded #{@students.count} students from #{filename}"
  else
    puts "Sorry #{filename} doesn't exist."
    exit
  end
end

def ask_for_file
  puts 'Enter file name: '
  collect_vaild_input(:filename)
end

try_load_file
interactive_menu
