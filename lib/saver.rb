# frozen_string_literal: true

require 'yaml'

# Class for saving and loading ongoing games
class Saver
  # Class methods
  class << self
    def save(yaml)
      file = File.new(yaml, 'w')
    end

    def load(yaml)
      # to do
    end
  end
end
