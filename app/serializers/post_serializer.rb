class PostSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :content, :created_at, :updated_at

end
