class Items::SearchesController < ApplicationController
  def index
    @items = Item.search(params[:key])
    @search = params[:key]
  end
  
end
