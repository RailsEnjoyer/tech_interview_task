class ComplexityScoreJob < ApplicationJob
  queue_as :score

  def perform(word)
    synonyms   = Rails.cache.read("synonyms_for_#{word}").to_i
    antonyms   = Rails.cache.read("antonyms_for_#{word}").to_i
    definitions = Rails.cache.read("definitions_for_#{word}").to_i

    return if definitions == 0 # or we divide by 0

    complexity = (synonyms + antonyms) / definitions.to_f

    Rails.cache.write("complexity_for_#{word}", complexity)
  end
end
