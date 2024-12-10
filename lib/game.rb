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

    input = nil

    loop do
      input = @player.input

      break unless @guesses.include? input

      puts 'Tried already'
    end

    process input

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
  def process(str)
    if @word.include? str
      @revealed << str
      puts 'Correct, next letter!'.light_green
    elsif %w[save load].include? str
      str == 'save' ? save_game : load_game
    else
      @attempts -= 1
      puts 'Incorrect, next try!'.light_red
    end

    # Don't add save/load commands to guesses
    @guesses << str unless %w[save load].include? str
  end

  # Saves the game to a yaml file
  def save_game
    yaml = yamlize

    dirname = 'saves'
    Dir.mkdir dirname unless Dir.exist? dirname

    filename = "#{Time.now.strftime '%d%m%y-%H%M'}.yaml"
    path = "#{dirname}/#{filename}"

    File.open(path, 'w') { |file| file.puts yaml }
  rescue Errno::ENOENT => e
    puts "Saving error: #{e}".light_red
  else
    puts "Game saved at: #{path}".light_green
  end

  def yamlize
    YAML.dump({
      word: @word, # rubocop:disable Layout/FirstHashElementIndentation
      attempts: @attempts,
      revealed: @revealed,
      guesses: @guesses
    }) # rubocop:disable Layout/FirstHashElementIndentation
  end

  # Loads the game from a yaml file
  def load_game
    # Get the names of saves
    saves = Dir['saves/*.yaml']

    puts 'Pick a save:'

    # Print the saves menu
    saves.each_with_index { |save, index| puts "#{index + 1}: #{save}" }

    save = pick_save saves

    deyamlize save
    puts "Save #{save.split('/').last} is successfully loaded".light_green
  end

  # Returns valid save path
  def pick_save(saveslist)
    input = nil

    # Ask a number until it's valid
    loop do
      input = gets.chomp
      break if (1..saveslist.size).include? input.to_i

      puts 'Wrong number'
    end

    saveslist[input.to_i - 1]
  end

  # Sets the game state from the save file
  def deyamlize(filepath)
    File.open(filepath) do |file|
      save = file.read
      # Uses #load instead of #save_load because of a bug with allowed data types
      data = YAML.load(save) # rubocop:disable Security/YAMLLoad
      p data

      @word = data[:word]
      @attempts = data[:attempts]
      @revealed = data[:revealed]
      @guesses = data[:guesses]
    end
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
