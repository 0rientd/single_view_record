# frozen_string_literal: true

require_relative "single_view_record/version"
require "colorize"

module SingleViewRecord
  def self.show(records)
    show_record(records.first)

    entry(get_input, 0, records)
    puts "\e[2J \e[0;0H"
  end
end

private

def show_record(record)
  puts "\e[2J \e[1;2H" + "#{'\\' * 10} ".green + "Object Class: " + "#{record.class}".red
  puts record.pretty_inspect

  print_nav_options
end

def print_nav_options
  rows, cols = IO.console.winsize
  nav_options = " [>] Next  | [<] Previous | [x] Exit "

  side_len = (cols - nav_options.length) / 2
  left_side  = "\\" * side_len
  right_side = "\\" * (cols - nav_options.length - side_len)

  print "\e[#{rows - 1};1H#{left_side.green}#{nav_options.blue}#{right_side.green}"
end

def entry(entry, index, records = nil)
  return if records.nil? || records.empty?

  case entry
  when ">"
    new_index = index + 1
  when "<"
    new_index = index - 1
  when "x"
    return
  else
    puts "Invalid input. Please try again."
    print_nav_options

    entry(get_input, index, records)
  end

  if new_index.between?(0, records.length - 1)
    show_record(records[new_index])
    entry(get_input, new_index, records)
  else
    puts "\a"
    show_record(records[index])
    entry(get_input, index, records)
  end
end

def get_input
  STDIN.raw do
    loop do
      char = STDIN.getc

      break if char == "\u0003" # Ctrl+C para sair
      break char if [">", "<", "x"].include?(char)

      print_nav_options
    end
  end
end