# frozen_string_literal: true

require_relative "single_view_record/version"

module SingleViewRecord
  def self.show(records)
    show_one_record(records.first)

    entry(get_input, 0, records)
  end

  private

  def self.show_one_record(record)
    puts "\e[2J\e[H"
    puts record

    print_nav_buttons
  end

  def self.print_nav_buttons
    terminal_size = IO.console.winsize

    puts "\e[#{terminal_size[0] - 1};1H Next Page [>] | Previous Page [<] | Exit [x]"
  end

  def self.entry(entry, index, records = nil)
    return if records.nil? || records.empty?

    case entry
    when ">"
      show_one_record(records[index + 1]) if records && records[index + 1]

      entry(get_input, index + 1, records)
    when "<"
      show_one_record(records[index - 1]) if records && records[index - 1]

      entry(get_input, index - 1, records)
    when "x"
      return
    else
      puts "Invalid input. Please try again."
      print_nav_buttons

      entry(get_input, index, records)
    end
  end

  def self.get_input
    STDIN.raw do
      loop do
        char = STDIN.getc

        break if char == "\u0003" # Ctrl+C para sair
        break char if [">", "<", "x"].include?(char)

        print_nav_buttons
      end
    end
  end
end
