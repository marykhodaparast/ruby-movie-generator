
require "faker"
require "digest"
require "yaml"

class MovieGenerator
  DATA = YAML.load_file(
    Rails.root.join("config/movie_data.yml")
  ).freeze

  def initialize(seed:, locale: "en-US", likes: 0, reviews: 3)
    @seed = seed.to_s
    @locale = locale
    @likes = Float(likes)
    @reviews = Integer(reviews)

    raise ArgumentError, "Unsupported locale" unless DATA.key?(@locale)
    raise ArgumentError, "Likes must be between 0 and 10" unless @likes.between?(0, 10)
    raise ArgumentError, "Reviews must be non-negative" if @reviews.negative?
  end

  def movie(index)
    data = DATA.fetch(@locale)
    random = Random.new(derived_seed(index, "details"))

    {
      index: index,
      title: "#{pick(data['title_first'], random)} #{pick(data['title_second'], random)}",
      actors: actors_for(index),
      year: random.rand(1970..2026),
      genre: pick(data["genres"], random),
      likes: likes_for(index),
      reviews: reviews_for(index)
    }
  end

  private

  def derived_seed(index, purpose)
    Digest::SHA256.hexdigest("#{@seed}:#{@locale}:#{index}:#{purpose}")[0, 16].to_i(16)
  end

  def pick(items, random)
    items.fetch(random.rand(items.length))
  end

  def actors_for(index)
    # Faker uses a configurable random generator.
    # Restore its previous generator after generating these names.
    previous_random = Faker::Config.random
    Faker::Config.random = Random.new(derived_seed(index, "actors"))
    Faker::Config.locale = (@locale == "de-DE" ? :de : :en)

    Array.new(3) { Faker::Name.name }
  ensure
    Faker::Config.random = previous_random if previous_random
  end

  def likes_for(index)
    whole = @likes.floor
    fraction = @likes - whole
    random = Random.new(derived_seed(index, "likes"))

    whole + (random.rand < fraction ? 1 : 0)
  end

  def reviews_for(index)
    data = DATA.fetch(@locale)
    random = Random.new(derived_seed(index, "reviews"))

    Array.new(@reviews) do
      pick(data["reviews"], random)
    end
  end
end
