class AntonymsParserJob < ApplicationJob
  queue_as :antonyms

  def perform(word)
    WordsParser.parse_antonyms(word).count.to_f

    Rails.cache.write("antonyms_for_#{word}", count)
  end
end
