class User
  include Mongoid::Document
  include Mongoid::Timestamps  

  field :name, type: String

  has_many :events
  has_many :buckets
end