class Bucket
  include Mongoid::Document
  include Mongoid::Timestamps  

  field :name, type: String

  has_many :events
  belongs_to :user

end