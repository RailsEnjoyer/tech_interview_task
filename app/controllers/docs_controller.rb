class DocsController < ActionController::API
  def readme
    render plain: File.read(Rails.root.join("README.md"))
  end
end
