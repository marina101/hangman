class Game
  attr_accessor :word, :count, :win, :answer_to_date, :letters_used, :game_name
  
  def initialize
    lines = File.readlines("5desk.txt")
     @word = generate_word(lines)[/[a-z]+/]
     @count = 12
     @game_name = ""
     @win = false
     @letters_used = []
     num = @word.length
     @answer_to_date = Array.new(num)
     @answer_to_date = @answer_to_date.map do |letter|
        letter = "_"
      end 
  end

  #generates a random word from the dictionary between 5 and 12 chars long
  def generate_word(words)
    have_num = false
    while(!have_num)
      num = rand(words.length+1)
      if (words[num].length <= 12 && words[num].length >= 5)
        return words[num].downcase
      end
    end 
  end

  def get_guess
    puts "\nYou have #{@count} turns left."
    puts "\nHere are the characters you have used so far: #{@letters_used.join(", ")}" if !@letters_used.empty?
    puts "\nHere is your word so far: #{@answer_to_date.join(" ")}"
    puts "\nPlease make your guess - enter a letter [a-z]:"
    guess = gets.chomp.downcase
    return guess
  end

  def check_guess(guess)
    @count -= 1
    letters_used.push(guess.to_s)
    if @word.include?(guess.to_s)
      temp_word = @word.clone
      until !temp_word.include?(guess.to_s)
        index = temp_word.index(guess.to_s)
        @answer_to_date[index] = guess.to_s
        check_win
        temp_word[index] = '_'
      end
      puts "\nThat letter is in the word! #{@answer_to_date.join(" ")}"
    else
      puts "\nSorry, that letter is not in the word"
    end
  end

  def check_win
    if @answer_to_date == @word.split(//)
      puts "\nCongratulations, you won!"
      @win = true
      return true
    else
      @win = false
      return false
    end
  end

  def out_of_turns
    if @count == 0
      puts "Sorry you have no more turns left"
      return true
    else
      false
    end
  end

end
