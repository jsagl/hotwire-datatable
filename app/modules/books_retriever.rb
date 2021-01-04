class BooksRetriever
  attr_accessor :params, :limit, :offset

  def initialize(params, limit, offset)
    self.params = params
    self.limit = limit
    self.offset = offset
  end

  def books
    return @books if @books

    books_query = Book.all
    books_query = books_query.where('author ILIKE ?', "%#{params[:author]}%") if params[:author].present?
    books_query = books_query.where('title ILIKE ?', "%#{params[:title]}%") if params[:title].present?
    books_query = books_query.where('publisher ILIKE ?', "%#{params[:publisher]}%") if params[:publisher].present?
    books_query = books_query.where('genre ILIKE ?', "%#{params[:genre]}%") if params[:genre].present?
    books_query = order.present? ? books_query.order(order) : books_query.order('title ASC')
    books_query = books_query.limit(limit).offset(offset)

    @books = books_query
  end

  def pages_count
    (books.except(:limit, :offset, :order).size / limit.to_f).ceil
  end

  private

  def order_mappings
    {
      'title_asc'  => 'title ASC',
      'author_asc' => 'author ASC',
      'publisher_asc' => 'publisher ASC',
      'genre_asc'   => 'genre ASC',
      'title_desc'  => 'title DESC',
      'author_desc' => 'author DESC',
      'publisher_desc' => 'publisher DESC',
      'genre_desc'   => 'genre DESC',
    }
  end

  def order
    params[:order].present? ? params[:order].split(',').map{|o| order_mappings[o] }.compact.join(', ') : nil
  end
end
