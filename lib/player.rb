# frozen_string_literal: true

# Class for human player, who guesses the word
class Player
  attr_reader :name

  def initialize
    puts "Hello! What's your name?"
    @name = gets.chomp
  end

  # Returns asked letter guess from the user
  def guess
    letter = nil
    puts 'Enter your letter:'

    # Ask a guess until it's one letter
    loop do
      letter = gets.chomp.downcase

      break if valid? letter

      puts 'Wrong input'
    end

    letter
  end

  private

  # Checks if user's char is letter
  def valid?(char)
    char.size == 1 && ('a'..'z').include?(char)
  end
end
