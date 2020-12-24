# ゲームの進行役クラス

require './player'
require './deck'
require './winning_role'
class GameProgress
    ALL_CHANGE = 10
    NO_EXCHANGE = 99
    MAX_HAND = 5

  def start
    puts "ポーカーを始めます"

    player_list = []
    # プレイヤーの登録
    player_list << Player.new(name: "A")
    player_list << Player.new(name: "B")
    player_list << Player.new(name: "C")
    # 山札の生成
    trump = Deck.new
    # 山札をシャッフルする
    trump.shuffle_deck

    # 各プレイヤーに手札を配る
    distribute_hand(player_list, trump.deck)
    
    puts <<~NOTICE

      ********************* 入力のルール *********************
      入れ替えるカードを選択してください
      最大#{MAX_HAND}枚まで入れ替え可能です。
      全て入れ替える場合は「#{ALL_CHANGE}」と入力して下さい。
      終了または、交換しない場合は「#{NO_EXCHANGE}」を入力してください。
      ********************************************************
    NOTICE

    player_list.each do |player|
      # 手札交換
      card_exchange(player, trump)
    end

    # 役の判定
    role_check(player_list)

    # 結果確認と表示
    check_result(player_list)

    # 勝者
    winner_list = winner(player_list)

    if winner_list.nil?
      puts "引き分けです"
    elsif winner_list.size == 1
      puts "勝者は#{winner_list[0].name}さんです！"
    else
      winner_list.each do |winner|
        puts "勝者は#{winner.name}さん！"
      end
    end
    
  end

  private
  # 各プレイヤーにカードを配る
  def distribute_hand(player_list, deck)
    player_list.each do |player|
      player.create_hand(deck.shift(MAX_HAND))
    end
  end
  def show_exchnge_rule()

  end

  def card_exchange(player, trump)
      change_flg = false
      # 手札入れ替え回数を格納
      input_count = 0
      # 交換した手札を一時格納
      tmp_card_list = []

      puts "【#{player.name}さん】のターンです"

      while change_flg == false do
        # 手札を表示
        puts ""
        puts "手札"
        player.hand.show_my_hand

        print "入れ替えるカードを選択してください："
        # 入力受付
        input = gets.to_i

        case input
        when NO_EXCHANGE
          change_flg = true
        when ALL_CHANGE
          player.hand.card_list = player.hand.all_change(trump.deck)
          change_flg = true
        # 交換していない手札の数
        when 1..player.hand.card_list.size

          # 交換した手札を一時格納
          tmp_card_list << player.hand.exchange(player.hand.card_list, trump.deck, input)
          input_count +=1

          # 5回交換したら、フラグを立てる
          if input_count == MAX_HAND
            change_flg = true
          end
        else
          # 異常入力がされた場合、警告メッセージを表示
          disp_waring_msg
        end
      end

      player.hand.card_list.concat(tmp_card_list) unless tmp_card_list.empty?
      puts <<~EXCHANGE
      手札入れ替えを終了します
      ***********************************
      #{player.name}さん：交換後の手札
      #{player.hand.show_my_hand}
      ***********************************

      EXCHANGE
  end

  def disp_waring_msg
    puts <<~WRAING

      ************************************
      入力された値は無効です。
      以下の選択肢の中から入力して下さい。
      「手札のインデックス」: 選択したカードを交換
      「#{ALL_CHANGE}」: 全て交換する
      「#{NO_EXCHANGE}」: 交換しない・交換を終了する
      ************************************

    WRAING
  end

  # 各プレイヤーの役のチェック
  def role_check(player_list)
    player_list.each do |player|
      role = WinningRole.decision_role(player.hand.card_list)
      player.hand.role = role.keys[0].to_s
      player.score = role.values[0].to_i
    end
  end
  
  # 結果確認
  def check_result(player_list)
    player_list.each do |player|
      puts "#{player.name}さんの結果"
      puts "*************************"
      puts "手札："
      player.hand.show_my_hand
      print "役："
      puts player.hand.role
      puts "*************************"
      puts ""

    end
  end

  # 勝者判定
  def winner(player_list)
    score_list = player_list.map{|player|player.score}
    if score_list.uniq.one?
    else
      max_score_player = player_list.max{|player| player.score }
      winner_list = []

      player_list.each do |player| 
        if player.score == max_score_player.score
          winner_list << player
        end
      end

      winner_list
    end
  end
end

game= GameProgress.new
game.start