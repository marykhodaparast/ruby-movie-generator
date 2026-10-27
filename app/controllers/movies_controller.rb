
class MoviesController < ApplicationController
  def index
    @seed = params[:seed].presence || "123456789"
    @locale = params[:locale].presence || "en-US"

    @likes = params[:likes].presence || "5"
    @review_count = params[:reviews].presence || "3"

    generator = MovieGenerator.new(
      seed: @seed,
      locale: @locale,
      likes: @likes,
      reviews: @review_count
    )

    all_movies = (1..20).map do |index|
      generator.movie(index)
    end

    @per_page = 5
    @total_pages = (all_movies.size.to_f / @per_page).ceil

    @page = params[:page].to_i
    @page = 1 if @page < 1
    @page = [@page, @total_pages].min

    @movies = all_movies.slice(
      (@page - 1) * @per_page,
      @per_page
    ) || []
    @next_page = @page + 1 if @page < @total_pages
    @gallery_movies = (1..5).map do |index|
  generator.movie(index)
end

@gallery_next_page = 2
  end

  def gallery
  @seed = params[:seed].presence || "123456789"
  @locale = params[:locale].presence || "en-US"
  @likes = params[:likes].presence || "5"
  @review_count = params[:reviews].presence || "3"

  generator = MovieGenerator.new(
    seed: @seed,
    locale: @locale,
    likes: @likes,
    reviews: @review_count
  )

  @page = [params[:page].to_i, 1].max
  per_page = 5
  start_index = (@page - 1) * per_page + 1

  @movies = (start_index..[start_index + per_page - 1, 20].min).map do |index|
    generator.movie(index)
  end

  @next_page = @page + 1 if start_index + per_page <= 20

  render partial: "movies/gallery_movies",
       locals: { movies: @movies, next_page: @next_page }
end
end
