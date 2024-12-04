class NoticesController < ApplicationController
  def index
    @notices = Notice.order(created_at: :desc) # お知らせを新しい順に取得
  end

  def show
    @notice = Notice.find(params[:id]) # URLの:idから特定のお知らせを取得
  end
end
