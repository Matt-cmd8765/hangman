class Computer
  attr_accessor :word
  @@array = []
  @@correct_length_array = []

  def file_read
    file = File.open('words.txt', 'r')
    file.each {|line| @@array << line.chomp}
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

