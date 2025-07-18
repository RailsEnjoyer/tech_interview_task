class Api::DataController < ApplicationController
  def index
    words = params[:word].to_s.split(",").map(&:strip).reject(&:blank?)

    words.each { |word| ComplexityScoreCounter.make_calcs(word) }

    result = words.map { |word| ComplexityScoreCounter.to_hash(word) }

    render json: result
  end
end
