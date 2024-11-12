class MuseumsController < ApplicationController
    before_action :authenticate_user!, except: [ :index ]
    before_action :set_museum, only: [ :show, :edit, :update, :destroy ]

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
        @categories = Category.all
    end

    def update
        if @museum.update(museum_params)
            redirect_to @museum, notice: "ミュージアム情報が更新されました。"
        else
            @categories = Category.all
            render :edit
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
end
