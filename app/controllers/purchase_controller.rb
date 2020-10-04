class PurchaseController < ApplicationController

  def index
  end

  def new
  end

  def show
    @comment = Comment.new
    @comment = @item.comments.includes(:user)
  end

end
