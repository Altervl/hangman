# frozen_string_literal: true

require 'colorize'
require_relative 'player'

# Main class of the project, holds the entire state of the game and results
class Game
  def initialize
    @player = Player.new
    @max_attempts = 10
    @attempts = @max_attempts
    @revealed = []
    @guesses = []
    @winner = false
  end

  # Runs the game loop
  def play
    @word = pick_word

    puts "Ok, #{@player.name}, let's start!"

    round until gameover?

    totalize
  end

  private

  # Returns a word between 5 and 12 chars long,
  # else alerts about error and quits the program
  def pick_word
    path = 'assets/words.txt'
    file = File.open path
  rescue Errno::ENOENT => e
    puts "Error: can't open words file - #{e}"
    exit
  else
    words = file.readlines.map(&:chomp)
    file.close

    # Filter words array by word size and return a random item
    filtered = words.filter { |w| (5..12).include? w.size }
    filtered.sample
  end

  # Runs a game round
  def round
    display

    letter = nil

    loop do
      letter = @player.guess

      break unless @guesses.include? letter

      puts 'Tried already'
    end

    process letter

    return unless solved?

    @winner = true
  end

  # Shows the state of game
  def display
    print 'Word: '
    @word.split('').each do |letter|
      if @revealed.include? letter
        print "#{letter} "
      else
        print '_ '
      end
    end

    print "| Attempts: #{ask_health}\n"
    puts "Guesses: #{@guesses.join ' '}"
  end

  # Shows quantity of attempts colorized
  def ask_health
    health = @attempts.to_f / @max_attempts * 10
    case health.to_i
    when 7..10
      @attempts.to_s.light_green
    when 4..7
      @attempts.to_s.light_yellow
    else
      @attempts.to_s.light_red
    end
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

    @guesses << guess
  end

  # Checks if the word riddle is solved
  def solved?
    (@word.split('') - @revealed).empty?
  end

  def gameover?
    @attempts.zero? || @winner == true
  end

  # Shows the game result
  def totalize
    if @winner
      puts 'Congrats, you won!'.light_cyan
    else
      puts 'No attempts left, game over. Better luck next time!'.light_magenta
    end

    puts "The word is '#{@word}'"
  end
end
