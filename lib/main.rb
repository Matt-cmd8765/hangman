# Save name, guess method
class Player
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def guess
    puts 'Guess a letter!'
    guess = gets.chomp
    until guess.match(/^[[:alpha:]]$/)
      puts 'Please enter a letter of the alphabet'
      guess = gets.chomp
    end
    guess.downcase
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
    length = @@correct_length_array.length
    @word = @@correct_length_array[rand(0..length)]
  end
end

# show hangman, take guesses
class Board
  attr_accessor :word, :array, :player_array

  def initialize(word)
    @word = word
    @array = word.split('')
  end

  def player_board
    @player_array = []
    length = @array.length
    length.times do
      @player_array << ' _ '
    end
  end

  def player_guess(guess)
    @array.each_with_index do |letter, index|
      @player_array[index] = guess if letter == guess
    end
  end
end

# load and save the game
class SaveAndLoad
  
end

# play the game
class Game
  attr_accessor :word, :player, :board, :game, :guess

  def generate_word
    comp = Computer.new
    comp.file_read
    comp.generate_word
    @word = comp.word
  end

  def show_board
    @board = Board.new(@word)
    @board.player_board
    puts ' '
    puts @board.player_array.join('')
    puts ' '
  end

  def player_info
    puts "Let's play hangman! Please tell me your name"
    name = gets.chomp
    @player = Player.new(name)
  end

  def the_guess
    @guess = @player.guess
    @board.player_guess(guess)
    puts @board.player_array.join('')
  end

  def winner?
    @word == @board.player_array.join('')
  end

  def da_game
    guess_limit = 6
    guess_num = 0
    while guess_num < guess_limit
      @game.the_guess
      da_word = @word.split('')
      guess_num += 1 unless da_word.include?(@guess)
      if @game.winner?
        puts "#{@player.name} wins! Your prize? Nothing."
        break
      end
      puts "#{guess_limit - guess_num} guesses remaining!" unless guess_num == 6
    end
  end

  def loser_statement
    puts "You lose! the word was #{@word}"
  end

  def play(game)
    @game = game
    game.generate_word
    game.show_board
    game.player_info
    game.da_game
    game.loser_statement unless game.winner?
  end
end

game = Game.new
game.play(game)