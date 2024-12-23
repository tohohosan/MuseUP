class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: [ :notes ]

    def notes
        # 指定されたユーザーの全メモを取得
        @notes = @user.notes.includes(:museum).order(created_at: :desc).page(params[:page])
        respond_to do |format|
            format.html # HTML のみ対応
        end
    end

    private

    def set_user
        @user = User.find(params[:user_id])
    end
end
