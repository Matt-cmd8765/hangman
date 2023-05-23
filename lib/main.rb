require 'yaml'

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
      @@correct_length_array << word if word.length >= 5 && word.length <= 12
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
  attr_accessor :serialized_object
  
  def initialize(game)
    @game = game
  end
  
  def save
    @serialized_object = YAML::dump(@game)
    Dir.mkdir('output') unless Dir.exist?('output')
    puts 'What would you like to call your saved game?'
    filename = gets.chomp
    file = "output/#{filename}.yml"
    File.open(file, 'w') do |the|
      the.puts @serialized_object
    end
  end

  def load_game
    puts 'Please select one of these saved games'
    filenames = Dir.glob('output/*').map { |file| file[(file.index('/')+1)...(file.index('.'))]}
    puts filenames
    file = gets.chomp
    saved = File.open("output/#{file}.yml", 'r')
    loaded_game = YAML.safe_load(saved, permitted_classes: [Game, Board, Player], aliases: true)
    saved.close
    loaded_game
  end
end

# play the game
class Game
  attr_accessor :word, :player, :board, :game, :guess, :guess_num, :player_array

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
    @guess_num = 0
  end

  def the_guess
    @guess = @player.guess
    @board.player_guess(guess)
    @player_array = @board.player_array.join('')
    puts @player_array
  end

  def winner?
    @word == @board.player_array.join('')
  end

  def da_game
    guess_limit = 6
    while guess_num < guess_limit
      @game.the_guess
      da_word = @word.split('')
      @guess_num += 1 unless da_word.include?(@guess)
      if @game.winner?
        puts "#{@player.name} wins! Your prize? Nothing."
        break
      end
      puts "#{guess_limit - @guess_num} guesses remaining!" unless @guess_num == 6
      puts 'Would you like to save the game? Type Y to save or press enter to continue playing.'
      answer = gets.chomp
      @game.save_game if answer == 'Y'
    end
  end

  def loser_statement
    puts "You lose! the word was #{@word}"
  end

  def save_game
    save = SaveAndLoad.new(@game)
    save.save
  end

  def load_game
    game = nil
    loadit = SaveAndLoad.new(game)
    @game = loadit.load_game
    puts ''
    puts @game.player_array
    @game.da_game
    @game.loser_statement unless @game.winner?
  end

  def play(game)
    @game = game
    game.generate_word
    game.show_board
    game.player_info
    game.da_game
    game.loser_statement unless game.winner?
  end

  def start_game(game)
    puts 'Load game (L) or start a new game (N)'
    answer = gets.chomp
    until answer == 'L' || answer == 'N'
      puts 'Please select load (L) or new game (N)'
      answer = gets.chomp
    end
    game.load_game if answer == 'L'
    game.play(game) if answer == 'N'
  end
end

game = Game.new
game.start_game(game)
