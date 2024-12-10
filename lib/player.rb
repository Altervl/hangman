# frozen_string_literal: true

require 'yaml'

# Class for human player, who guesses the word
class Player
  attr_reader :name

  def initialize
    puts "Hello! What's your name?"
    @name = gets.chomp
  end

  # Returns asked letter guess from the user or saves/loads the game
  def input
    value = nil
    puts 'Enter your letter or "save"/"load" for save/load your game:'

    # Ask a guess until it's one letter
    loop do
      value = gets.chomp.downcase

      break if valid? value

      puts 'Wrong input'
    end

    value
  end

  private

  # Checks if user input is valid
  def valid?(str)
    letter?(str) || save_load?(str)
  end

  # Checks if str is letter
  def letter?(str)
    str.size == 1 && ('a'..'z').include?(str)
  end

  # Checks if str is save/load command
  def save_load?(str)
    %w[save load].include?(str)
  end
end
