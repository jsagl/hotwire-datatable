class BooksRetriever
  attr_accessor :params

  def initialize(params)
    self.params = params
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

    @books ||= books_query
  end

  def limit
    params[:limit].present? ? params[:limit].to_i : 10
  end

  def selected_page
    params[:page].to_i.zero? ? 1 : params[:page].to_i
  end

  def offset
    (selected_page - 1) * limit
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
