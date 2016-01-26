class Card
  attr_accessor :rank, :suit

  def initialize(rank, suit)
    @rank, @suit = rank, suit
  end

  def to_s
    @rank.to_s.capitalize + " of " + @suit.to_s.capitalize
  end

  def ==(other)
    @rank == other.rank and @suit == other.suit
  end
end

class Deck < Card

  include Enumerable

  attr_accessor :cards

  def initialize(cards_array = make_array_of_cards)
    @cards = cards_array
  end

  def ranks
    [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]
  end

  def suits
    [:clubs, :diamonds, :hearts, :spades]
  end

  def make_array_of_cards
    suits.product(ranks).map { |suit, rank| Card.new(rank, suit) }
  end

  def each
    @cards.each {|card| yield card}
  end

  def to_s
    string = ""
    @cards.each {|card| string << card.to_s + "\n"}
    string
  end

  def size
    @cards.size
  end

  def draw_bottom_card
    @cards.pop
  end

  def draw_top_card
    @cards.shift
  end

  def shuffle
    @cards.shuffle!
  end

  def top_card
    @cards.at(0)
  end

  def bottom_card
    @cards.at(-1)
  end

  def cards_by_suit(suit)
    @cards.select {|card| card.suit == suit}
  end

  def ranks_by_suit(suit)
    cards_by_suit(suit).map {|card| card.rank}
  end

  def sort
    @cards.sort! do |x, y|
      comp = (suits.index(y.suit) <=> suits.index(x.suit))
      comp.zero? ? (ranks.index(y.rank) <=> ranks.index(x.rank)) : comp
    end
    @cards
  end

  def deal(amount_of_cards, players_deck)
    amount_of_cards.times do
      players_deck.cards.push(self.draw_top_card)
    end
  end
end

class WarDeck < Deck
  def deal
    players_deck = WarPlayersDeck.new
    super(26, players_deck)
    players_deck
  end
end

class WarPlayersDeck < Deck
  def initialize
    @ranks = [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]
    @cards = Array[]
  end

  def play_card
    @cards.delete_at((0..(cards.size - 1)).to_a.sample)
  end

  def allow_face_up?
    @cards.size <= 3
  end
end

class  BeloteDeck < Deck
  def ranks
    [7, 8, 9, :jack, :queen, :king, 10, :ace]
  end

  def deal
    players_deck = BelotePlayersDeck.new
    super(8, players_deck)
    players_deck
  end

  def sort
    super()
  end
end


class BelotePlayersDeck < Deck
  def initialize
    @ranks = [7, 8, 9, :jack, :queen, :king, 10, :ace]
    @cards = Array[]
  end

  def highest_of_suit(suit)
    self.sort
    (@cards.select {|card| card.suit == suit}).at(0)
  end

  def four_of_a_kind?(rank)
    @cards.select {|card| card.rank == rank}.size == 4
  end

  def has?(suit, rank)
    @cards.any? {|card| card.rank == rank && card.suit == suit}
  end

  def belote?
        couples = 0
        suits = [:spades, :hearts, :diamonds, :clubs]
        suits.each do |suit|
          if (has?(suit, :king) && has?(suit, :queen))
            couples = couples + 1
          end
        end
        couples > 0
  end

  def tierce?
    sequence?(3)
  end

  def quarte?
    sequence?(4)
  end

  def quint?
    sequence?(5)
  end

  def carre_of_jacks?
    four_of_a_kind?(:jack)
  end

  def carre_of_nines?
    four_of_a_kind?(9)
  end

  def carre_of_aces?
    four_of_a_kind?(:ace)
  end

  def sequence?(number)
    suits.any? do |suit|
      rank = ranks_by_suit(suit)
      ranks.each_cons(number).any? do |consecutive_ranks|
        (consecutive_ranks & rank).size == number
      end
    end
  end
end

class  SixtySixDeck < Deck
  def ranks
    [9, :jack, :queen, :king, 10, :ace]
  end

  def deal
    players_deck = SixtySixPlayersDeck.new
    super(6, players_deck)
      players_deck
  end
end

class SixtySixPlayersDeck < Deck
  def initialize
    @ranks = [9, :jack, :queen, :king, 10, :ace]
    @cards = Array[]
  end

  def has?(suit, rank)
    @cards.any? {|card| card.rank == rank && card.suit == suit}
  end

  def twenty?(trump_suit)
    couples = 0
    suits = [:spades, :hearts, :diamonds, :clubs] - [trump_suit]
    suits.each do |suit|
      if (has?(suit, :king) && has?(suit, :queen))
        couples = couples + 1
      end
    end
    couples > 0
  end

  def forty?(trump_suit)
    has?(suit, :king) && has?(suit, :queen)
  end
end