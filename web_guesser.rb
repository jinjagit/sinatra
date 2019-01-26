require 'sinatra'
require 'sinatra/reloader'

class Guess_Me
  attr_accessor :message, :background, :new_prompt

  def initialize
    @attempts = 0
    @number = rand(100)
    @message = ''
    @new_prompt = ''
    @background = ''
    @new_game = true
  end

  def play_round(guess = nil, cheat = false)
    @new_prompt = ''
    if @attempts == 0 && @new_game == true
      @message = 'Make your first guess...'
      @background = "yellow"
      @new_game = false
      @attempts += 1
    elsif @attempts < 5 && guess != @number
      @attempts += 1
      @message = "attempt #{@attempts} of 5: " + check_guess(guess)
      set_background(guess)
    else
      set_background(guess)
      if guess == @number
        @message = "YOU WIN! Secret number was #{@number}"
      else
        @message = "YOU LOSE! Secret number was #{@number}"
      end
      @new_prompt = "Try again? (New secret number generated)"
      @attempts = 0
      @number = rand(100)
    end
    if cheat == 'true'
      @message += " [cheat: secret number = #{@number}]"
    end
  end

  def check_guess(guess)
    if guess > @number
      guess > @number + 5 ? @message = "WAY too high!" : @message = "Too high."
    elsif guess < @number
      guess < @number - 5 ? @message = "WAY too low!" : @message = "Too low."
    end
  end

  def set_background(guess)
    if guess == @number
      @background = "green"
    else
      (guess - @number).abs > 5 ? @background = "red" : @background = "#ff8484"
    end
  end
end

cheat = 'false'
game = Guess_Me.new

get '/' do
  guess = params['guess'].to_i
  cheat = params['cheat']
  game.play_round(guess, cheat)
  erb :index, :locals => {:message => game.message,
                          :background => game.background,
                          :new_prompt => game.new_prompt}
end
