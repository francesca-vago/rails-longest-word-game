require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    array1 = ('a'..'z').to_a.sample(5)
    array2 = ('a'..'z').to_a.sample(5)
    @letters = array1.concat(array2)
  end

  def score
    @answer = params[:answer]
    @token = params[:token]
    if check_include?
      if check_valid?
        @message = "Congratulations! #{@answer} is a valid English word"
      end
    end
  end

  private

  def check_include?
    answer_to_check = @answer.downcase.chars
    token_to_check = @token.delete(' ').chars
    answer_to_check.each do |char|
      break if token_to_check.include?(char)

      @message = "Sorry but #{@answer} can't be built out of #{@token}"
    end
  end

  def check_valid?
    dictionary = json_parse
    return if dictionary['found']

    @message = "Sorry but #{@answer} does not seem to be a valid English word"
  end

  def json_parse
    url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
    serialized_dictionary = open(url).read
    JSON.parse(serialized_dictionary)
  end
end
