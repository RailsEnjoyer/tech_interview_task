class SynonymsParserJob < ApplicationJob
  queue_as :synonyms

  def perform(word)
    count = WordsParser.parse_synonyms(word).count

    # caching synonyms count
    Rails.cache.write("synonyms_for_#{word}", count)
  end
end
