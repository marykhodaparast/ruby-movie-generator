
require "test_helper"

class MovieGeneratorTest < ActiveSupport::TestCase
  test "same seed and index produce identical movies" do
    first = MovieGenerator.new(
      seed: "123456789",
      locale: "en-US"
    ).movie(1)

    second = MovieGenerator.new(
      seed: "123456789",
      locale: "en-US"
    ).movie(1)

    assert_equal first, second
  end

  test "different seeds produce different movies" do
    first = MovieGenerator.new(
      seed: "123456789",
      locale: "en-US"
    ).movie(1)

    second = MovieGenerator.new(
      seed: "987654321",
      locale: "en-US"
    ).movie(1)

    assert_not_equal first, second
  end

  test "different indexes produce different movies" do
    generator = MovieGenerator.new(
      seed: "123456789",
      locale: "en-US"
    )

    first = generator.movie(1)
    second = generator.movie(2)

    assert_not_equal first, second
  end

  test "movie contains the expected fields" do
    movie = MovieGenerator.new(
      seed: "123456789",
      locale: "en-US"
    ).movie(1)

    assert_equal 1, movie[:index]
    assert_kind_of String, movie[:title]
    assert_equal 3, movie[:actors].length
    assert movie[:year].between?(1970, 2026)
    genres = MovieGenerator::DATA.fetch("en-US").fetch("genres")
    assert_includes genres, movie[:genre]
  end
end
