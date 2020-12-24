require './hand'
# プレイヤークラス
# 手札やスコアなど、結果確認の際に必要となる処理を実装
class Player
  attr_accessor :name, :score, :hand

  def initialize(**param)
    @name = param[:name]
    @score = 0
  end

  # 各プレイヤーに手札を配る
  def create_hand(card_list)
    @hand = Hand.new(card_list: card_list)
  end

end