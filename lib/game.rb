# frozen_string_literal: true

require_relative 'computer'
require_relative 'player'

# Main class of the project, holds the entire state of the game and results
class Game
  def initialize
    @player = Player.new
    @computer = Computer.new
    @word = nil
    @attempts = 7
    @hidden = @word.split ''
    @revealed = []
  end

  def play
    # to do
  end
end
