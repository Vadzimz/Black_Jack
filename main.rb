require_relative 'player'
require_relative 'user'
require_relative 'dealer'
require_relative 'game'


CARDS = (2..10).to_a.map(&:to_s).concat(["V", "Q", "K", "A"]).
  product(["\u2660", "\u2663", "\u2665", "\u2666"]).map(&:join)

COSTS = ((2..10).to_a.concat([10] * 3 + [11]) * 4).sort

class Game_interface

  attr_accessor :my_game, :me
  def initialize
    @my_game = nil
    @me = nil
  end

  def join_the_game
    print "Would you like to play (Y/N)"
    s = gets.chomp.upcase
    validate_confirmation input: s
    if s == "Y"
      self.my_game = Game.new
      puts "Input your name"
      self.me = Player.new(gets.chomp.capitalize)
      self.my_game.add_player(me)
      puts "You are ready to play now"
    else
      puts "See you soon"
    end
    rescue StandardError => e
      puts "#{e.message}. Try again"
    retry
  end

  def start_the_game
    my_game.start
    loop do 
      me.show_results
      make_a_choice
      break if my_game.active == false
      my_game.active_player.auto
      break if my_game.active == false
      my_game.players.first.show_results(show: false)
    end
    print "Would you like to repeat (Y/N)"
    s = gets.chomp.upcase
    validate_confirmation input: s
    s == "Y" ? start_the_game : (print "See you later")
    rescue StandardError => e
      puts "#{e.message}. Try again"
    retry
  end

  def make_a_choice
    puts "Make your choice"
    ["Skip my turn", "One more card", "Open cards"].each_with_index { |v, i| puts "#{i} : #{v}" }
    print '> '
    s = gets.chomp
    validate_choosing input: s
    case s.to_i
      when 0; me.skip
      when 1; me.add_a_card
      when 2; me.open_cards
    end
    rescue StandardError => e
      puts "#{e.message}. Try again"
    retry
  end

  def validate_confirmation(input:)
    raise 'Your input is out of variants to choose' unless ["Y", "N"].include?(input.upcase)
  end

  def validate_choosing(input:)
    raise 'Your input is out of variants to choose' if input.to_i.to_s != input || !(0..2).include?(input.to_i)
  end
end
  
    

