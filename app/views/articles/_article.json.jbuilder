json.extract! article, :id, :name, :preview, :text, :author, :created_at, :updated_at
json.url article_url(article, format: :json)
