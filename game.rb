class Game

  attr_accessor :players, :cards, :game_bank, :active_player, :active

  def initialize
    @players = [Player.new("Dealer")]
    @cards = CARDS.dup
    @game_bank = 0
    @active = false
    @active_player = nil
  end

  def add_player(player)
    self.players << player unless players.include?(player)
  end

  def start
    starting_point
    self.game_bank += players.length * 10
    
    players.map do |p|
      p.game = self
      p.player_bank -= 10
      2.times{ p.add_a_card }
    end
  end

  def starting_point
    loop do
        self.players.rotate!
        break if players.first.name == "Dealer"
    end
    self.active_player = players.last
    self.active = true
    self.cards.shuffle!
  end

  def pass
    self.players.rotate!
    self.active_player = players.last
  end

  def finish
    puts "The game is over"
    puts "The results:"
    if players.map(&:cards_amount).uniq.count == 1
      players.map{ |p| p.player_bank += 10}
      puts "The drawn game"
    else
      winner = players.select{ |p| p.cards_amount < 22 }.sort_by(&:cards_amount).last
      winner.player_bank += game_bank
      puts "The winner #{winner.name}"
    end
    players.each{ |p| p.show_results}
    self.active = false
    players.map{ |p| p.cards = [] }
  end
end
