require "open-uri"
require "json"

class GamesController < ApplicationController
  def new
    @letters = (0...10).map { ('A'..'Z').to_a[rand(26)] }
  end

  def score
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    result = JSON.parse(URI.open(url).read)
    if result["found"] && check_letters_in_grid?(params[:word], params[:letters])
      @score = "Congratulations! Your word #{params[:word]} gives you : #{result["length"]} points"
    elsif result["found"] && !check_letters_in_grid?(params[:word], params[:letters])
      @score = "Sorry but #{params[:word]} can't be built out of #{params[:letters]}"
    else
      @score = "Sorry but #{params[:word]} is not an english word"
    end
  end

  def check_letters_in_grid?(word, letters)
    word.chars.all? do |letter|
      word.upcase.count(letter.upcase) <= letters.count(letter.upcase)
    end
  end
end
