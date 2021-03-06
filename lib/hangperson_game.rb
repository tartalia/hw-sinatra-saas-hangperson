class HangpersonGame
  attr_reader :word, :guesses, :wrong_guesses
  MAX_GUESS = 7

  # Get a word from remote "random word" service
  def initialize(word)
    @word = word.downcase
    @guesses = ''
    @wrong_guesses = ''
    @word_with_guesses = word.downcase
  end

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end

  def word_with_guesses
    gword = ''
    @word.each_char do | c |
      if @guesses.index(c) != nil then gword += c else gword += '-' end
    end
    gword
  end

  def check_win_or_lose
    return :lose if @wrong_guesses.length == 7
    if word_with_guesses == @word
      return :win
    else
      return :play
    end
  end

  def guess(letter)
    raise ArgumentError if letter == '' || letter == nil
    raise ArgumentError if /[^A-Za-z]/ =~ letter
    letter = letter.downcase
    if @word.index(letter) != nil
      if @guesses.index(letter) == nil
        @guesses << letter
        return true
      end
    else
      if @wrong_guesses.index(letter) == nil
        @wrong_guesses << letter
        return true
      end
    end
    false
  end
end
