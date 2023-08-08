class CommentsController < ApplicationController
    
    http_basic_authenticate_with name: "dhh", password: "secret", only: :destroy
    
    def create
        @piece = Piece.find(params[:piece_id])
        @comment = @piece.comments.create(comment_params)
        redirect_to piece_path(@piece)
    end

    def destroy
        @piece = Piece.find(params[:piece_id])
        @comment = @piece.comments.find(params[:id])
        @comment.destroy
        redirect_to piece_path(@piece), status: :see_other
    end

    private
        def comment_params
            params.require(:comment).permit(:commenter, :body, :status)
        end
end
