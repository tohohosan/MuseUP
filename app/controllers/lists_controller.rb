class ListsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_list, only: [ :show, :edit, :update, :destroy, :add_museum ]

    def index
        @lists = current_user.lists
    end

    def show
        @museums = @list.museums
        @museum_data = @museums.select(:id, :name, :latitude, :longitude).to_json
    end

    def new
        if params[:museum_id].present?
            begin
                @museum = Museum.find(params[:museum_id])
            rescue ActiveRecord::RecordNotFound
                flash.now[:alert] = "指定された博物館が見つかりませんでした。"
                @museum = nil
            end
        end
        @list = List.new
    end

    def create
        @list = current_user.lists.build(list_params)
        if @list.save
            redirect_to lists_path, notice: "リストを作成しました。"
        else
            flash.now[:alert] = "リストの作成に失敗しました。"
            render :new
        end
    end

    def edit
    end

    def update
        if @list.default?
            redirect_to lists_path, alert: "このリストは名前を変更できません。"
        else
            if @list.update(list_params)
                redirect_to lists_path, notice: "リストを更新しました。"
            else
                flash.now[:alert] = "リストの更新に失敗しました。"
                render :edit
            end
        end
    end

    def destroy
        @list.destroy
        redirect_to lists_path, notice: "リストを削除しました。"
    end

    def add_museum
        museum = Museum.find(params[:museum_id])
        unless @list.museums.include?(museum)
            @list.museums << museum
        end
        redirect_back fallback_location: museum_path(museum), notice: "リストに追加しました。"
    end

    private

    def set_list
        @list = current_user.lists.find(params[:id])
    end

    def list_params
        params.require(:list).permit(:name)
    end
end
