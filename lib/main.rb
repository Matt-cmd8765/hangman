# Save name, guess method
class Player
  attr_accessor :name

  def initialize(name)
    @name = name
  end
end

# generate word
class Computer
  attr_reader :word

  @@array = []
  @@correct_length_array = []

  def file_read
    file = File.open('words.txt', 'r')
    file.each { |line| @@array << line.chomp }
    file.close
  end

  def generate_word
    @@array.each do |word|
      if word.length >= 5 && word.length <= 12
        @@correct_length_array << word
      end
    end
    @word = @@correct_length_array[rand(0..7556)]
  end
end


# show hangman
class Board
end

# load and save the game 
class SaveAndLoad
end


class Game
end

gat = Computer.new
gat.file_read
gat.generate_word
puts gat.word

name = gets.chomp
player = Player.new(name)
puts player.name
