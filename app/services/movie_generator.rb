
require "faker"
require "digest"

class MovieGenerator
  GENRES = %w[
    Action Adventure Animation Comedy Crime Drama Fantasy
    Horror Mystery Romance Science Fiction Thriller
  ].freeze

  def initialize(seed:, locale: "en-US")
    @seed = seed.to_s
    @locale = locale
  end

  def movie(index)
    seed = movie_seed(index)

    # Reset Faker's random generator for deterministic results.
    Faker::Config.random = Random.new(seed)
    Faker::Config.locale = faker_locale

    random = Random.new(seed)

    {
      index: index,
      title: random_title(random),
      actors: Array.new(3) { Faker::Name.name },
      year: random.rand(1970..2026),
      genre: GENRES[random.rand(GENRES.length)]
    }
  end

  private

  def movie_seed(index)
    Digest::SHA256.hexdigest("#{@seed}:#{index}")[0, 16].to_i(16)
  end

  def faker_locale
    @locale == "de-DE" ? :de : :en
  end

  def random_title(random)
    first = %w[
      Silent Hidden Broken Last Midnight
      Fading Lost Crimson Golden Distant
    ]

    second = %w[
      Horizon Promise Kingdom Memory Signal
      Shadow Journey Empire Secret Storm
    ]

    "#{first[random.rand(first.length)]} " \
      "#{second[random.rand(second.length)]}"
  end
end
