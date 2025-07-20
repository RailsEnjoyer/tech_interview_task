class AntonymsParserJob < ApplicationJob
  queue_as :antonyms

  def perform(word)
    count = WordsParser.parse_antonyms(word).count.to_f

    # caching antonyms count
    Rails.cache.write("antonyms_for_#{word}", count)
  end
end
