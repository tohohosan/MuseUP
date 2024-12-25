# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def show
    @user = current_user
  end

  def create
    build_resource(sign_up_params)

    if resource.save
      flash[:notice] = "ユーザー登録に成功しました。" # 成功メッセージ
      sign_up(resource_name, resource)
      respond_with resource, location: after_sign_up_path_for(resource)
    else
      flash[:alert] = resource.errors.full_messages.join("。")
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
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
