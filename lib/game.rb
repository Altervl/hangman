# frozen_string_literal: true

require_relative 'computer'
require_relative 'player'
require_relative 'display'

# Main class of the project, holds the entire state of the game and results
class Game
  attr_reader :player, :computer, :display, :word, :state
  attr_accessor :attempts, :hidden, :revealed, :message

  def initialize
    @player = Player.new
    @computer = Computer.new
    @display = Display.new
    @attempts = 7
    @hidden = @word.split ''
    @revealed = []
    @message = 'Try a letter!'
    @state = [attempts, hidden, revealed, message]
  end

  def play
    @word = computer.pick_word

    display.show state

    while attempts.positive?
      letter = player.guess

      process letter

      if hidden.empty?
        @message = 'Congratulations, you won!'

        display.show state
        exit
      end

      display.show state
    end
  end

  def process(guess)
    if word.include? guess
      revealed << guess
      hidden.delete guess
      @message = 'Correct!'
    else
      @attempts -= 1
      @message = 'Incorrect. Next try!'
    end
  end
end
