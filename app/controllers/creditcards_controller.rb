class CreditcardsController < ApplicationController
  require 'payjp'

  before_action :set_item, only:[:show,:pay]
  before_action :take_card, only:[:index,:show,:pay,:delete]
  before_action :set_api_key


  def index
    if @creditcard.blank?
      #登録された情報がない場合にカード登録画面に移動
      flash[:notice] = 'カード情報を登録してください'
      redirect_to new_creditcard_path and return
    else
      #保管した顧客IDでpayjpから情報取得
      set_customer
      #保管したカードIDでpayjpから情報取得、カード情報表示のためインスタンス変数に代入
      set_card_information
    end

  end

  def show 
    if @creditcard.blank?
      #登録された情報がない場合にカード登録画面に移動
      flash[:alert] = '購入前にカード登録してください'
      redirect_to new_creditcard_path and return
    else
      #保管した顧客IDでpayjpから情報取得
      set_customer
      #保管したカードIDでpayjpから情報取得、カード情報表示のためインスタンス変数に代入
      set_card_information
    end
    # if current_user.address == nil
    #     flash[:alert] = '購入前に住所登録してください'
    #     redirect_to new_address_path
    # end
  end

  def create
    if params['payjp-token'].blank?
      redirect_to action: "new"
      # トークンが取得出来てなければループ
    else
      user_id = current_user.id
      customer = Payjp::Customer.create(
      card: params['payjp-token']
      # params['payjp-token']（response.id）からcustomerを作成
      ) 
      @card = Creditcard.new(user_id: user_id, customer_id: customer.id, card_id: customer.default_card)
      if @card.save
        flash[:notice] = '登録しました'
        redirect_to "/"
      else
        flash[:alert] = '登録できませんでした'
        redirect_to action: "new"
      end
    end
  end

  def pay
    @item.update(buyer_id: current_user.id)
    # 現在のユーザーを購入者に登録
    Payjp::Charge.create(
    :amount => @item.price, 
    :customer => @creditcard.customer_id, 
    :currency => 'jpy', #日本円
   )
    redirect_to root_path
  # ホーム画面に遷移
  end

  def delete #PayjpとCardデータベースを削除します
    
    if @creditcard.present?
      set_customer
      @customer.delete
      @creditcard.delete
    end
      redirect_to action: "new"
  end

private

  def set_item
    @item = Item.find(params[:id])
  end

  def set_api_key
    Payjp.api_key = Rails.application.credentials[:payjp][:PAYJP_PRIVATE_KEY]
  end

  def set_customer
    @customer = Payjp::Customer.retrieve(@creditcard.customer_id)
  end

  def set_card_information
    @creditcard_information = @customer.cards.retrieve(@creditcard.card_id)
  end

  def take_card
    @creditcard = Creditcard.find_by(user_id: current_user.id)
  end

end