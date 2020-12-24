# 役の判定クラス
# 役の定義と判定判定処理のみを実装
class WinningRole
  class << self
    # 役一覧
    NO_PIAR = {"ノーペア": 0}
    # ワンペア
    PAIR = {"ワンペア": 1}
    # ツーペア
    TWO_PAIR = {"ツーペア": 2}
    # スリーカード
    THREE_CARD = {"スリーカード": 3}
    # ストレート
    STRAIGHT = {"ストレート": 4}
    # フラッシュ
    FLUSH = {"フラッシュ": 5}
    # フルハウス
    FULL_HOUSE = {"フルハウス": 6}
    # フォーカード
    FOUR_CARD = {"フォーカード": 7}
    # ストレートフラッシュ
    STRAIGHT_FLUSH = {"ストレートフラッシュ": 8}
    # ロイヤルストレートフラッシュ
    ROYAL_FLUSH = {"ロイヤルストレートフラッシュ": 9}

    ROYAL_FLUSH_ARY = [1, 10, 11, 12, 13]

    CROSS_OVER_STRAIGHT_ART= [10, 11, 12, 13, 1]

    # 役判定用メソッド
    def decision_role(card_list)
      case true
        # ロイヤルストレート・フラッシュ 
      when royal_flush?(card_list)
        ROYAL_FLUSH
        # ストレート・フラッシュ
      when straight_flush?(card_list)
        STRAIGHT_FLUSH
        # フォーカード
      when four_card?(card_list)
        FOUR_CARD
        # フルハウス
      when full_house?(card_list)
        FULL_HOUSE
        # フラッシュ
      when flush?(card_list)
        FLUSH
        # ストレート
      when straight?(card_list)
        STRAIGHT
        # スリーカード
      when three_card?(card_list)
        THREE_CARD
        # ツーペア
      when two_pair?(card_list)
        TWO_PAIR
        # ワンペア
      when pair?(card_list)
        PAIR
      else
        # ノーペア
        NO_PIAR
      end
    end

    private
    # ロイヤルフラッシュ
    def royal_flush?(card_list)
      if same_suit?(card_list)
        cards = card_list.map{|card| card.values}.flatten
        cards.sort ==  ROYAL_FLUSH_ARY ? true : false
      end
    end

    # ストレートフラッシュ
    def straight_flush?(card_list)
      same_suit?(card_list) && consecutive_number?(card_list) ? true : false
    end 

    # フォーカード
    def four_card?(card_list)
      inculde_pair?(card_list, 4) ? true : false
    end

    # フルハウス 
    def full_house?(card_list)
      list = card_list.map{|card| card.values}.flatten
      three_pair_flg = false
      two_pair_flg = false

      list.group_by(&:itself).values.each do |pair_ary|

        if pair_ary.size == 3
          three_pair_flg = true
        elsif pair_ary.size == 2
          two_pair_flg = true
        end
      end
      three_pair_flg && two_pair_flg ? true : false
    end

    # フラッシュ
    def flush?(card_list)
      same_suit?(card_list) ? true : false
    end

    # ストレート
    def straight?(card_list)
      consecutive_number?(card_list) ? true : false
    end

    # スリーカード
    def three_card?(card_list)
      inculde_pair?(card_list, 3) ? true : false
    end

    # ツーペア
    def two_pair?(card_list)
      list = card_list.map{|card| card.values}.flatten
      pairs = []
      list.group_by(&:itself).values.each do |pair_ary|
        pairs << pair_ary if pair_ary.size == 2
      end
      pairs.size == 2 ? true : false
    end

    # ワンペア
    def pair?(card_list)
      inculde_pair?(card_list, 2) ? true : false
    end

    def inculde_pair?(card_list, pairs)
      list = card_list.map{|card| card.values}.flatten

      list.group_by(&:itself).values.each do |pair_ary|
        if pair_ary.size == pairs
          return true
        end
      end
      false
    end

    # スートの判定
    def same_suit?(card_list)
      suits = card_list.map{|card|card.keys}.flatten
      true if suits.uniq.one?
    end

    # 連続した数字の判定
    def consecutive_number?(card_list)
      list = card_list.map{|card| card.values}.flatten
      list.sort!
      if list.include?(1) &&  list.each.any?{|card| card >= 10}
        ace = list.shift
        list << ace
        true if CROSS_OVER_STRAIGHT_ART == list
      else
        first_number = list.first
        list.each_with_index do |card, index|
          return false unless card - first_number == index
        end
        return true
      end
    end
  end
end