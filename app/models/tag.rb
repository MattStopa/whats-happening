class Tag < ActiveRecord::Base
  has_many :tag_list, :class_name => 'TagsList'
  has_many :events, through: :tag_list

  def as_json(options = nil)
    {
        id: id,
        value: title
    }
  end
end