class Bucket
  include Mongoid::Document
  include Mongoid::Timestamps  

  field :name, type: String
  field :count, type: Integer, default: 1

  def increase_bucket_count
    self.count = self.count || 0
    self.count += 1
    self.save
    self.count
  end

  has_many :events
  belongs_to :user

end