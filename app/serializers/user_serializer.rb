class UserSerializer

  include JSONAPI::Serializer
  attributes :id, :email, :name, :username, :phone
  has_many :posts, serializer: PostSerializer

end