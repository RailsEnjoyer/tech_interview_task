class CalculateComplexityJob < ApplicationJob
  queue_as :default

  def perform(words, job_id)
    status = JobStatus.find_by(job_id: job_id)
    return unless status

    status.update(status: "pending")
    result = {}

    words.each do |word|
      SynonymsParserJob.perform_later(word)
      AntonymsParserJob.perform_later(word)
      DefinitionsParserJob.perform_later(word)

      # waiting till all jobs are completed
      10.times do
        break if all_cached?(word)
        sleep 0.5
      end

      # reading all cache (count) for synonims, antonyms, definitions
      data = ComplexityScoreCounter.fetch_components(word)

      # fetching score for the word
      score = ComplexityScoreCounter.call(data[:synonyms], data[:antonyms], data[:definitions])
      result[word] = score
    end

    sleep 15 # slowing down execution

    status.update(status: "completed", result: result)
  end

  private

  def all_cached?(word)
    %w[synonyms antonyms definitions].all? do |type|
      Rails.cache.exist?("#{type}_for_#{word}")
    end
  end
end
