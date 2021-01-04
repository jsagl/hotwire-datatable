class BooksController < ApplicationController
  before_action :find_book, only: [:edit, :update]

  def index
    retriever = BooksRetriever.new(params)

    @limit = retriever.limit
    @selected_page = retriever.selected_page
    @books = retriever.books
    @pages_count = retriever.pages_count

    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  def edit
  end

  def update
    @book.update!(permitted_params.slice(:title, :author, :publisher, :genre))
  end

  private

  def find_book
    @book = Book.find(params[:id])
  end

  def permitted_params
    params.require(:book).permit(:title, :author, :publisher, :genre)
  end
end


