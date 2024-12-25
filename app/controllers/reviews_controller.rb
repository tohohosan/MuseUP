class ReviewsController < ApplicationController
    before_action :authenticate_user!, except: [ :index, :new ]
    before_action :set_museum, only: [ :index, :new, :create, :edit, :update, :destroy ]
    before_action :set_review, only: [ :edit, :update, :destroy ]
    before_action :authorize_user!, only: [ :edit, :update, :destroy ]

    def index
        @reviews = @museum.reviews.includes(:user).order(created_at: :desc).page(params[:page])
    end

    def new
        @review = @museum.reviews.new
    end

    def create
        @review = @museum.reviews.new(review_params)
        @review.user = current_user

        if @review.save
            redirect_to @museum, notice: "レビューが投稿されました。"
        else
            flash[:alert] = @review.errors.full_messages.join("。")
            render :new, status: :unprocessable_entity
        end
    end

    def edit; end

    # レビューの更新
    def update
        if @review.update(review_params)
            redirect_to @museum, notice: "レビューが更新されました。"
        else
            flash[:alert] = @review.errors.full_messages.join("。")
            render :edit, status: :unprocessable_entity
        end
    end

    # レビューの削除
    def destroy
        @review.destroy
        redirect_to @museum, notice: "レビューが削除されました。"
    end

    private

    # ミュージアム情報を取得
    def set_museum
        @museum = Museum.find(params[:museum_id])
    end


    # レビュー情報を取得
    def set_review
        @review = @museum.reviews.find(params[:id])
    end

    # ユーザー権限を確認
    def authorize_user!
        redirect_to museum_reviews_path(@museum), alert: "他のユーザーのレビューを編集・削除することはできません。" unless @review.user == current_user
    end

    # 許可されたパラメータ
    def review_params
        params.require(:review).permit(:content, :rating)
    end
end
