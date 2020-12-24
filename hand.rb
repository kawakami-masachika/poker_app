# 手札クラス
# 手札に関する処理を実装
class Hand
  attr_accessor :card_list, :role
  def initialize(param)
    @card_list  = param[:card_list]
  end

  # 対象プレイヤーの手札を表示する
  def show_my_hand
    @card_list.each.with_index(1) do |card, index|
      trump = card.to_a
      puts "#{index}:#{trump.join}"
    end
  end

  # カードを捨てて、交換する
  def exchange(card_list, deck, select_card)

    card_list.delete_at(select_card.to_i-1)

    deck.shift(1)[0]
  end

  # 手札を全て交換する
  def all_change(deck)
    size = @card_list.size

    card_list.clear

    @card_list = deck.shift(size)
  end
end