require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    # Generate an array of 10 random letters
    all_letters = ("A".."Z").to_a
    @letters = 10.times.map { all_letters.sample }
  end

  def score
    guess = params[:guess]
    check_word(guess)
  end

  # The word can’t be built out of the original grid
  # The word is valid according to the grid, but is not a valid English word
  # The word is valid according to the grid and is an English word

  # Check if valid EN word
  def check_word(guess)
    url = "https://wagon-dictionary.herokuapp.com/#{guess}"
    serialized_response = URI.open(url).read # A string E.g. {"found":true,"word":"apple","length":5}
    @response = JSON.parse(serialized_response) # a hash

    if inside_grid && @response["found"]
      @message = "Congratulations! #{guess} is a valid English word!"
    elsif (inside_grid == false) && @response["found"]
      @message = "Sorry but #{guess} can't be built out of the available letters"
    else
      @message = "Sorry but #{guess} does not seem to be a valid English word..." # and score =0
    end
  end

  def inside_grid
    # validate that every letter in the word exists in the grid
    @response["word"].split("").each do |letter|
      if params[:letters].split.include?(letter)
        true
      else
        false
      end
    end
  end
end
