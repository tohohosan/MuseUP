class MuseumsController < ApplicationController
    before_action :authenticate_user!, except: [ :index ]
    before_action :set_museum, only: [ :show, :edit, :update, :destroy ]
    before_action :authorize_user!, only: [ :edit, :update, :destroy ]

    def index
        @museums = Museum.all
        @total_museum_count = @museums.count
        @user_museum_count = current_user.museums.count if user_signed_in?
    end

    def show
        @museum = Museum.find(params[:id])
        respond_to do |format|
            format.html
            format.json { render json: @museum }
        end
    end

    def new
        @museum = current_user.museums.build
        @categories = Category.all
    end

    def create
        @museum = current_user.museums.build(museum_params)
        respond_to do |format|
            if @museum.save
                format.html { redirect_to new_museum_path, notice: "ミュージアムが投稿されました。" }
            else
                @categories = Category.all
                flash.now[:alert] = "ミュージアムの投稿に失敗しました。"
                format.html { render :new, status: :unprocessable_entity }
            end
        end
    end

    def edit
        @museum = Museum.find(params[:id])
        @categories = Category.all
    end

    def update
        if @museum.update(museum_params)
            redirect_to @museum, notice: "ミュージアム情報が更新されました。"
        else
            @categories = Category.all
            flash.now[:alert] = "ミュージアムの更新に失敗しました。"
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @museum.destroy
        redirect_to museums_path, notice: "ミュージアムが削除されました。"
    end

    private

    def set_museum
        @museum = Museum.find(params[:id])
    end

    def museum_params
        params.require(:museum).permit(:name, :address, :description, :url, images: [], category_ids: [])
    end

    def authorize_user!
        unless @museum.user == current_user
            redirect_to museums_path, alert: "このミュージアムを更新する権限がありません。"
        end
    end

    def remove_image
        @museum = Museum.find(params[:id])
        image = @museum.images.find(params[:image_id])
        image.purge # ActiveStorage の画像を削除
        redirect_to edit_museum_path(@museum), notice: "画像を削除しました。"
    end
end
