class ItemsController < ApplicationController

  before_action :set_item, only: [:show, :destroy, :edit, :update]


  def index
    @genre_parents = Genre.where("ancestry is null")
    @items = Item.limit(5).order(updated_at: :desc)
    #ホームページのピックアップに記載される情報は商品名・価格・画像のみ
  end

  def new
    @item = Item.new
    @genre_parent =  Genre.where("ancestry is null")
  end
  # 親ジャンルが選択された後に動くアクション

  def genre_children
    @genre_children = Genre.find("#{params[:parent_id]}").children
    #親ジャンルに紐付く子ジャンルを取得
  end

  # 子ジャンルが選択された後に動くアクション
  
  def genre_grandchildren
    @genre_grandchildren = Genre.find("#{params[:child_id]}").children
    #子ジャンルに紐付く孫ジャンルの配列を取得
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      flash.now[:alert] = '出品できませんでした'
      render :new
    end
  end

  # 商品詳細表示のアクション
  def show
    @comment = Comment.new
    @comments = @item.comments.includes(:user)
    @destination = Destination.find_by(user_id: @item.seller_id)
  end

  # 商品編集のアクション
  def edit
    @genre_parent =  Genre.where("ancestry is null")
  end

  def update
    if  params[:item][:image_ids].present?
      params[:item][:image_ids].each do |image_id|
        image = @item.images.find(image_id)
        image.purge
      end
    end
    if @item.update(item_params)
      redirect_to item_path(@item)
    else
      flash.now[:alert] = '更新できませんでした'
      render :edit
    end
  end
      
  # 商品削除のアクション
  def destroy
    if @item.destroy
      redirect_to root_path
    else
      render :show
    end
  end

  # 商品検索のアクション
  def search
    @items = Item.search(params[:key])
    if params[:key] == ""
      redirect_to '/items/search?utf8=✓&keyword=+++'
    end

    if @items.count == 0
      @all_items = Item.limit(25).order("id DESC")
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :introduction, :genre_id, :brand, :condition_id, :delivery_fee_id, :pref_id, :day_id, :price, images: []).merge(seller_id: current_user.id)
  end

  def set_item
    @item = Item.find(params[:id])
  end

end
