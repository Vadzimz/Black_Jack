class Player

  attr_accessor :name, :player_bank, :game, :cards

  def initialize(name)
    @name = name 
    @player_bank = 100
    @game = nil
    @cards = []
  end

  def skip
    game.pass
  end

  def add_a_card
    self.cards << game.cards.shift
    cards.count == 3 ? open_cards : skip
  end

  def open_cards
    game.finish
  end

  def auto
    cards_amount < 17 ? add_a_card : skip
  end

  def cards_amount
    val = COSTS.values_at(* cards.map{ |c| CARDS.find_index(c) }).sum

    case cards.count{|c| CARDS.find_index(c) > 47}
    when 0; return val
    when 1; return [val, val - 10].select{|s| s <= 21}.max
    when 2; return [val - 10, val -20].select{|s| s <= 21}.max
    when 3; return 13
    end
  end

  def show_results(show: true)
    if show
        puts "#{name}: Cards: #{cards} Sum: #{cards_amount} Bank: #{player_bank}"
    else
      ["*"] * cards.count
      puts "#{name}: Cards: #{["*"] * cards.count} Bank: #{player_bank}"
    end
  end
end