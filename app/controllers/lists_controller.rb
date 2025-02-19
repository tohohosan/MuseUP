class ListsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_list, only: [ :show, :edit, :update, :destroy, :add_museum, :remove_museum ]

    def index
        @lists = current_user.lists.includes(:museums).order(created_at: :asc).page(params[:page])
        @museum = Museum.find(params[:museum_id]) if params[:museum_id].present?
        @list_museums_counts = @lists.map { |list| [ list.id, list.museums.size ] }.to_h

        respond_to do |format|
            format.html
            format.js
        end
    end

    def show
        @list = List.find(params[:id])
        @museums = @list.museums.includes(:images).order(created_at: :asc).page(params[:page]).per(6)

        respond_to do |format|
            format.html
            format.js
        end
    end

    def new
        @list = List.new
    end

    def create
        @list = current_user.lists.build(list_params)
        if @list.save
            redirect_to lists_path, notice: "リストを作成しました。"
        else
            flash[:alert] = @list.errors.full_messages.join("。")
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
                flash[:alert] = @list.errors.full_messages.join("。")
                render :edit
            end
        end
    end

    def destroy
        @list.destroy
        redirect_to lists_path, notice: "リストを削除しました。"
    end

    def add_museum
        @museum = Museum.find(params[:museum_id])
        unless @list.museums.include?(@museum)
            @list.museums << @museum
        end

        @list_museums_counts = @list.user.lists.joins(:museums).group(:id).count

        respond_to do |format|
            format.turbo_stream { render turbo_stream: turbo_stream.replace("museum_button_#{@museum.id}", partial: "lists/museum_button", locals: { list: @list, museum: @museum }) }
            format.html { redirect_to request.referer, notice: "リストに追加しました。" }
        end
    end

    def remove_museum
        @museum = Museum.find(params[:museum_id])
        if @list.museums.include?(@museum)
            @list.museums.delete(@museum)
            flash[:notice] = "リストから削除しました。"
        else
            flash[:alert] = "指定された博物館はリストに登録されていません。"
        end

        @list_museums_counts = @list.user.lists.joins(:museums).group(:id).count

        respond_to do |format|
            format.turbo_stream { render turbo_stream: turbo_stream.replace("museum_button_#{@museum.id}", partial: "lists/museum_button", locals: { list: @list, museum: @museum }) }
            format.html { redirect_to request.referer, notice: "リストから削除しました。" }
        end
    end

    private

    def set_list
        @list = current_user.lists.find(params[:id])
    end

    def list_params
        params.require(:list).permit(:name)
    end
end
