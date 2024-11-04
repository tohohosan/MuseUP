# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def show
    @user = current_user
  end

  def edit
  end

  def update
    @user = current_user
    if @user.update_without_password(account_update_params)
      flash[:notice] = "プロフィールを更新しました。"
      redirect_to user_path(current_user.id)
    else
      flash.now[:alert] = "プロフィールの更新に失敗しました。"
      render :edit
    end
  end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  private

  def account_update_params
    if params[:user][:password].blank?
      params.require(:user).permit(:name, :email, :image)
    else
      params.require(:user).permit(:name, :email, :password, :image)
    end
  end
end
