class WordsParser
  DICTIONARY_URL = "https://api.dictionaryapi.dev/api/v2/entries/en/"

  def self.parse_synonyms(word)
    data = fetch_data(word)
    return [] unless valid_response?(data)

    deep_extract(data, "synonyms").flatten.compact.uniq
  end

  def self.parse_antonyms(word)
    data = fetch_data(word)
    return [] unless valid_response?(data)

    deep_extract(data, "antonyms").flatten.compact.uniq
  end

  def self.parse_definitions(word)
    data = fetch_data(word)
    return [] unless valid_response?(data)

    deep_extract(data, "definition").flatten.compact.uniq
  end

  private

  def self.fetch_data(word)
    response = Faraday.get("#{DICTIONARY_URL}#{word}")
    return nil unless response.success?

    JSON.parse(response.body)
  rescue JSON::ParserError => e
    Rails.logger.error("WordsParser JSON error: #{e.message}")
    nil
  rescue StandardError => e
    Rails.logger.error("WordsParser error: #{e.message}")
    nil
  end

  def self.valid_response?(data)
    data.is_a?(Array) && data.first.is_a?(Hash)
  end

  def self.deep_extract(obj, key)
    results = []

    case obj
    when Array
      obj.each { |item| results.concat(deep_extract(item, key)) }
    when Hash
      results << obj[key] if obj.key?(key)
      obj.each_value { |value| results.concat(deep_extract(value, key)) }
    end

    results
  end
end
