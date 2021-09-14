#! usr/bin/env ruby
# frozen_string_literal: true

@students = []

# students = [
#   { name: 'Dr. Hannibal Lecter', cohort: :november },
#   { name: 'Darth Vader', cohort: :november },
#   { name: 'Nurse Ratched', cohort: :november },
#   { name: 'Michael Corleone', cohort: :november },
#   { name: 'Alex DeLarge', cohort: :november },
#   { name: 'The Wicked Witch of the West', cohort: :november },
#   { name: 'Terminator', cohort: :november },
#   { name: 'Freddy Krueger', cohort: :november },
#   { name: 'The Joker', cohort: :november },
#   { name: 'Joffrey Baratheon', cohort: :november },
#   { name: 'Norman Bates', cohort: :november }
# ]

KEY_TO_REGEX = {
  cohort: /(Jan|Febr)uary|March|April|May|June|July|August|(Septem|Octo|Novem|Decem)ber/i,
  favorite_animal: /\w+/i,
  height: /\d+/i
}.freeze

def input_students
  puts "Please enter the name of the student: \n(To finish, hit return twice)"

  name = $stdin.gets.chomp
  collect_students(name)
end

def collect_students(name)
  until name.empty?
    info = collect_additional_info

    @students << {
      name: name, cohort: info[:cohort].to_sym, favorite_animal: info[:favorite_animal], height: info[:height]
    }

    students_so_far(@students.count)
    name = $stdin.gets.chomp
  end
end

def collect_additional_info
  information = %i[cohort favorite_animal height].to_h { |sym| [sym, ''] }

  information.each_key do |key|
    puts "Enter student's #{key.to_s.sub(/_/, ' ')}: "

    information[key] = collect_vaild_input(key)
  end
  information
end

def collect_vaild_input(key)
  loop do
    user_input = $stdin.gets.chomp
    break user_input if user_input.match(KEY_TO_REGEX[key])
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
    print_menu
    process($stdin.gets.chomp)
  end
end

def print_menu
  puts "1. Input the students\n2. Show the students\n3. Save students list\n4. Load Student list\n9. Exit"
end

def process(user_choice) # rubocop:disable Metrics/MethodLength
  case user_choice
  when '1'
    input_students
  when '2'
    show_students
  when '3'
    save_students
    puts 'Students file save completed'
  when '4'
    load_student
    puts 'Students file loaded'
  when '9'
    exit
  else
    puts 'Invaild selection, try again: '
  end
end

def show_students
  print_header
  print_students_list(only_cohort_group)
  print_footer(@students.count)
end

def save_students
  file = File.open('students.csv', 'w')

  @students.each do |student|
    csv_line = student.values.join(',')

    file.puts csv_line
  end
  file.close
end

def load_student(filename = 'students.csv')
  file = File.open(filename, 'r')

  file.readlines.each do |line|
    name, cohort, favorite_animal, height = line.chomp.split(',')
    @students << {
      name: name, cohort: cohort.to_sym, favorite_animal: favorite_animal, height: height
    }
  end
  file.close
end

def try_load_file
  filename = ARGV.first
  return if filename.nil?

  if File.exist?(filename)
    load_student(filename)
    puts "Loaded #{@students.count} students from #{filename}"
  else
    puts "Sorry #{filename} doesn't exist."
    exit
  end
end

try_load_file
interactive_menu
