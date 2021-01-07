class BooksController < ApplicationController
  before_action :find_book, only: [:show, :edit, :update, :destroy]

  def index
    @limit = params[:limit].present? ? params[:limit].to_i : 10
    @selected_page = params[:page].to_i.zero? ? 1 : params[:page].to_i

    retriever = books_retriever(@limit, @selected_page)

    @books = retriever.books
    @pages_count = retriever.pages_count

    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  def show
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(permitted_params)

    respond_to do |format|
      if @book.save
        format.turbo_stream
        format.html { redirect_to books_url(@book) }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    @book.update!(permitted_params.slice(:title, :author, :publisher, :genre))

    redirect_to book_url(@book)
  end

  def destroy
    @book.destroy

    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  private

  def find_book
    @book = Book.find(params[:id])
  end

  def permitted_params
    params.require(:book).permit(:title, :author, :publisher, :genre)
  end

  def books_retriever(limit, selected_page)
    offset = (selected_page - 1) * limit
    BooksRetriever.new(params, limit, offset)
  end
end


