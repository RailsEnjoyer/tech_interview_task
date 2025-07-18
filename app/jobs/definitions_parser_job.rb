class DefinitionsParserJob < ApplicationJob
  queue_as :definitions

  def perform(word)
    count = WordsParser.parse_definitions(word).count
    Rails.cache.write("definitions_for_#{word}", count)
  end
end
