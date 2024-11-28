class MuseumsController < ApplicationController
    before_action :authenticate_user!, except: [ :index, :show ]
    before_action :set_museum, only: [ :show, :edit, :update, :destroy ]
    before_action :authorize_user!, only: [ :edit, :update, :destroy ]

    def index
        # Ransack の検索オブジェクトを作成
        @q = Museum.ransack(params[:q])
        # 検索結果を適用（デフォルトはすべてのミュージアム）
        @museums = @q.result.includes(:categories)
        # 検索結果件数を計算
        @search_results_count = @museums.count

        @total_museum_count = Museum.count
        @user_museum_count = current_user.museums.count if user_signed_in?

        @map_center = if @museums.present?
                        { lat: @museums.first.latitude, lng: @museums.first.longitude }
        else
                        { lat: 35.778429, lng: 136.815916 } # デフォルト位置
        end
    end

    def show
        @museum = Museum.find(params[:id])
        @reviews = @museum.reviews.includes(:user).order(created_at: :desc).page(params[:reviews_page])

        if user_signed_in?
            @lists = current_user.lists.includes(:museums).order(created_at: :asc).page(params[:lists_page])
            @list_museums_counts = @lists.map { |list| [ list.id, list.museums.size ] }.to_h
            @note = @museum.notes.find_by(user: current_user)
        else
            @lists = Kaminari.paginate_array([]).page(1)
            @list_museums_counts = nil
            @note = nil
        end

        respond_to do |format|
            format.html
            format.js
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
        # 新しい画像がある場合は追加、既存の画像を保持
        if params[:museum][:images]
            params[:museum][:images].each do |new_image|
                @museum.images.attach(new_image)
            end
        end

        if @museum.update(museum_params.except(:images))
            redirect_to @museum, notice: "ミュージアム情報が更新されました。"
        else
            @categories = Category.all
            flash.now[:alert] = @museum.errors.full_messages.to_sentence
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @museum.destroy
        redirect_to museums_path, notice: "ミュージアムが削除されました。"
    end

    def remove_image
        @museum = Museum.find(params[:id])
        image = @museum.images.find_by(id: params[:image_id])

        if image.present?
            image.purge
            flash[:notice] = "画像が削除されました。"
        else
            flash[:alert] = "画像が見つかりませんでした。"
        end

        redirect_to edit_museum_path(@museum)
    end

    def nearest
        latitude = params[:latitude].to_f
        longitude = params[:longitude].to_f

        # Geocoder を使って現在地に最も近いミュージアムを検索
        nearest_museum = Museum.near([ latitude, longitude ], 50).first

        if nearest_museum
            render json: { museum: nearest_museum }
        else
            render json: { museum: nil }
        end
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
end
