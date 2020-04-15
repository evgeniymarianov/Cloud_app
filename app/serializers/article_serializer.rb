class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :name, :preview, :text, :author
end
