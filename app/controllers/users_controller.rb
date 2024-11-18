class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: [ :notes ]

    def notes
        # 指定されたユーザーの全メモを取得
        @notes = @user.notes.includes(:museum)
    end

    private

    def set_user
        @user = User.find(params[:user_id])
    end
end
