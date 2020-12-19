# 手札クラス
# 手札に関する処理を実装
class Hand
  attr_accessor :card_list, :role
  def initialize(param)
    @card_list  = param[:card_list]
  end

  def show_my_hand
    @card_list.each.with_index(1) do |card, index|
      trump = card.to_a
      puts "#{index}:#{trump.join}"
    end
  end

  # カードを捨てて、交換する
  def exchange(card_list, deck, select_card)
    # 選択されたカードを削除
    card_list.delete_at(select_card.to_i-1)
    # 新たに1枚を山札から補充
    deck.shift(1)[0]
  end

  def all_change(trump)
    # 手札の枚数を確認
    size = @card_list.size

    # 手札を全て捨てる
    card_list.clear

    # 捨てた分だけ手札を補充
    @card_list = trump.shift(size)
  end
end