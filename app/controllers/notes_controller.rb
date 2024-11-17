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
            redirect_to @museum, notice: "メモを保存しました。"
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
    end

    def update
        if @note.update(note_params)
            redirect_to @museum, notice: "メモを更新しました。"
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @note.destroy
        redirect_to @museum, notice: "メモを削除しました。"
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
end
