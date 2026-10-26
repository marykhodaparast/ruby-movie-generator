
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

    @movies = (1..20).map do |index|
      generator.movie(index)
    end
  end
end
