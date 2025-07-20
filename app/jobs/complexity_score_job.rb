class ComplexityScoreJob < ApplicationJob
  queue_as :score

  def perform(word)
    data = ComplexityScoreCounter.fetch_components(word)
    score = ComplexityScoreCounter.call(data[:synonyms], data[:antonyms], data[:definitions])

    # caching complexity count
    Rails.cache.write("complexity_for_#{word}", score)
  end
end
