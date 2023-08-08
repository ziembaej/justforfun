class PiecesController < ApplicationController
  
  #http_basic_authenticate_with name: "dhh", password: "secret",
  #except: [:index, :show]

  def index
    @pieces = Piece.all
  end

  def show
    @piece = Piece.find(params[:id])
  end

  def new
    @piece = Piece.new
  end

  def create
    @piece = Piece.new(piece_params)

    if @piece.save
      redirect_to @piece
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @piece = Piece.find(params[:id])
  end

  def update
    @piece = Piece.find(params[:id])

    if @piece.update(piece_params)
      redirect_to @piece
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @piece = Piece.find(params[:id])
    @piece.destroy

    redirect_to root_path, status: :see_other
  end

  private
    def piece_params
      params.require(:piece).permit(:title, :body, :status)
    end

end
