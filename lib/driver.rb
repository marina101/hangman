require_relative 'game.rb'
require 'pstore'

def save_game(game)
  puts "What name do you want to save it under?"
  name = gets.chomp
  game.game_name = name
  store = PStore.new("storagefile")
    store.transaction do
    store[:games] ||= Array.new
    store[:games] << game
  end
  puts "Your game has been saved"
end

def load_game
  store = PStore.new("storagefile")
  local_games = []
  store.transaction do
    local_games = store[:games]
  end
  puts "Here are the games you can load:"
  local_games.each_with_index do |game, index|
    puts "game: #{game.game_name} with index #{index}"
  end
  puts "Please enter the index of the game you want to play:"
  answer = gets.chomp
  return local_games[answer.to_i]
end



puts "Welcome to the hangman! You will try to guess the letters of a mystery word\n"
game1 = Game.new
finished = false

while (!finished) do 
  begin

    while (!game1.out_of_turns && !game1.check_win)
      puts "Enter '1' to make a guess, '2' to save your game, or '3' to load a game"
      answer = gets.chomp
      case answer
      when '1'
        guess = game1.get_guess
        raise ArgumentError, "Please enter just one character "if guess.length > 1
        game1.check_guess(guess)
      when '2'
        save_game(game1)
      when '3'
        game1 = load_game
      else
        raise ArgumentError, "Please enter 1, 2, or 3"
      end
    end

    puts "The correct answer was #{game1.word}"

    puts "Do you want to play again? Type 'y' if yes, any other key to quit"
    play_again = gets.chomp
    finished = true unless play_again.downcase == 'y'
  rescue => e
      puts e
  end
end

