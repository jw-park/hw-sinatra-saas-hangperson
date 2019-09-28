class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  attr_accessor :word, :guesses, :wrong_guesses
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

  def guess(letter)

    raise ArgumentError, 'Argument is empty' unless not(letter.nil?) and not(letter.empty?) and (letter =~ /[[:alpha:]]/)

    letter = letter.downcase

    if word.include? letter
      if guesses.include? letter
        return false
      end
      guesses << letter
    else
      if wrong_guesses.include? letter
        return false
      end
      wrong_guesses << letter
    end
  end

  def word_with_guesses
    word_chars = word.chars.to_a
    display_word = ''
    word_chars.each { |c|
      if guesses.include? c
        display_word << c
      else
        display_word << '-'
      end
    }
    display_word
  end

  def check_win_or_lose
    if word.chars.to_a.uniq.length == guesses.length
      :win
    elsif wrong_guesses.length >= 7
      :lose
    else
      :play
    end
  end

end
