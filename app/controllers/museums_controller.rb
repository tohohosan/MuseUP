class MuseumsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_museum, only: [ :show, :edit, :update, :destroy ]

    def index
        @museums = Museum.all
    end

    def show
    end

    def new
        @museum = current_user.museums.build
        @categories = Category.all
    end

    def create
        @museum = current_user.museums.build(museum_params)
        if @museum.save
            redirect_to @museum, notice: "ミュージアムが投稿されました。"
        else
            @categories = Category.all
            render :new
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
        params.require(:museum).permit(:name, :address, :description, category_ids: [], images: [])
    end
end
