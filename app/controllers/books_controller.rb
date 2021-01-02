class BooksController < ApplicationController
  before_action :find_book, only: [:edit, :update]

  def index
    order_mappings = {
      'title_asc'  => 'title ASC',
      'author_asc' => 'author ASC',
      'publisher_asc' => 'publisher ASC',
      'genre_asc'   => 'genre ASC',
      'title_desc'  => 'title DESC',
      'author_desc' => 'author DESC',
      'publisher_desc' => 'publisher DESC',
      'genre_desc'   => 'genre DESC',
    }

    order = params[:order].present? ? params[:order].split(',').map{|o| order_mappings[o] }.compact.join(', ') : nil
    @limit = params[:limit].present? ? params[:limit].to_i : 10
    @selected_page = params[:page].to_i.zero? ? 1 : params[:page].to_i
    offset = (@selected_page - 1) * @limit

    @books = Book.all
    @books = @books.where('author ILIKE ?', "%#{params[:author]}%") if params[:author].present?
    @books = @books.where('title ILIKE ?', "%#{params[:title]}%") if params[:title].present?
    @books = @books.where('publisher ILIKE ?', "%#{params[:publisher]}%") if params[:publisher].present?
    @books = @books.where('genre ILIKE ?', "%#{params[:genre]}%") if params[:genre].present?

    @pages_count = (@books.except(:limit, :offset, :order).size / @limit.to_f).ceil

    @books = order.present? ? @books.order(order) : @books.order('title ASC')
    @books = @books.limit(@limit).offset(offset)


    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  def edit
  end

  def update
    @book.update!(permitted_params)
  end

  private

  def find_book
    @book = Book.find(params[:id])
  end

  def permitted_params
    params.require(:book).permit(:title, :author, :publisher, :genre)
  end
end


