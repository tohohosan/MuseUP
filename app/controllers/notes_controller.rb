class NotesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_museum
    before_action :set_note, only: [ :show, :edit, :update, :destroy ]

    def show
        redirect_to @museum, alert: "メモが見つかりません。" unless @note
    end

    def new
        @note = @museum.notes.find_or_initialize_by(user: current_user)
    end

    def create
        @note = @museum.notes.find_or_initialize_by(user: current_user)
        if @note.update(note_params)
            redirect_to determine_redirect_path, notice: "メモを保存しました。"
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
    end

    def update
        if @note.update(note_params)
            redirect_to determine_redirect_path, notice: "メモを更新しました。"
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @note.destroy
        redirect_to determine_redirect_path, notice: "メモを削除しました。"
    end

    private

    def set_museum
        @museum = Museum.find(params[:museum_id])
    end

    def set_note
        @note = @museum.notes.find_by(user: current_user)
    end

    def note_params
        params.require(:note).permit(:content)
    end

    def determine_redirect_path
        if request.referer&.include?(museum_path(@museum))
            museum_path(@museum) # ミュージアム詳細画面
        elsif request.referer&.include?(notes_user_path(current_user))
            notes_user_path(current_user) # マイページのメモ画面
        else
            museum_path(@museum) # デフォルトはミュージアム詳細画面
        end
    end
end
