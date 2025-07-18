class ComplexityScoreCounter
  def self.make_calcs(word)
    [
      SynonymsParserJob.perform_later(word),
      AntonymsParserJob.perform_later(word),
      DefinitionsParserJob.perform_later(word)
    ]
  end

  def self.to_hash(word)
    ComplexityScoreJob.perform_later(word)
  end
end