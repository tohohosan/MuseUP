class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: [ :notes ]

    def notes
        @notes = @user.notes.includes(:museum).order(created_at: :desc).page(params[:page])

        respond_to do |format|
            format.html
            format.js
        end
    end

    private

    def set_user
        @user = User.find(params[:user_id])
    end
end
