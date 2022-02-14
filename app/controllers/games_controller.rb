require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    @included = included?(@word, @letters)
    @english_word = english_word?(@word)
    @score = compute_score(@word)
    session[:score] ? session[:score] += @score : session[:score] = @score
  end

  def compute_score(word)
    # time_taken > 60.0 ? 0 : word.size * (1.0 - time_taken / 60.0)
    word.length
  end
end
