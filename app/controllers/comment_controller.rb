class CommentController < ApplicationController
  before_action :set_item

  def create
    comment = Comment.new(comment_params)
    if comment.save
      redirect_to item_path(@item), notice: 'コメントが保存されました'
    else
      comment = @item.comments.includes(:user)
      flash.now[:alert] = "保存できていません"
      redirect_to item_path(params[:id])
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:comment).merge(user_id: current_user.id, item_id: params[:item_id])
  end

  def set_item
    @item = Item.find(params[:item_id])
  end
end
