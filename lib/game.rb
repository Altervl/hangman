# frozen_string_literal: true

require 'colorize'
require_relative 'computer'
require_relative 'player'

# Main class of the project, holds the entire state of the game and results
class Game
  def initialize
    @player = Player.new
    @computer = Computer.new
    @attempts = 7
    @revealed = ''
    @winner = false
  end

  # Runs the game loop
  def play
    @word = @computer.pick_word

    # Continues while they're attempts left
    while @attempts.positive?
      display

      letter = @player.guess

      process letter

      @winner = true if @revealed == @word
    end

    totalize
  end

  # Shows the letter if guess is right or decreases the attempts else,
  # notifies the player
  def process(guess)
    if @word.include? guess
      @revealed << guess
      puts 'Correct, next letter!'.light_green
    else
      @attempts -= 1
      puts 'Incorrect, next try!'.light_red
    end
  end

  # Shows the state of game
  def display
    @word.each do |letter|
      if @revealed.include? letter
        print "#{letter} "
      else
        print '_ '
      end
    end

    ask_health
  end

  private

  # Shows quantity of attempts colorized
  def ask_health
    case @attempts
    when 5..7
      puts @attempts.to_s.light_green
    when 2..4
      puts @attempts.to_s.light_yellow
    when 0..2
      puts @attempts.to_s.light_red
    end
  end

  # Shows the game result
  def totalize
    if @winner
      puts 'Congrats, you won!'.light_cyan
    else
      puts 'No attempts left, game over. Better luck next time!'.light_magenta
    end
  end
end
