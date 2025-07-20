class ComplexityScoreCounter
  def self.fetch_components(word)
    {
      synonyms: Rails.cache.read("synonyms_for_#{word}").to_f,
      antonyms: Rails.cache.read("antonyms_for_#{word}").to_f,
      definitions: Rails.cache.read("definitions_for_#{word}").to_f
    }
  end

  def self.call(synonyms, antonyms, definitions)
    return 0.0 if definitions.zero? # ZeroDivisionError preventing

    (synonyms + antonyms) / definitions.to_f
  end
end
