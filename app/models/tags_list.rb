class TagsList < ActiveRecord::Base
    self.table_name = "tags_list"
    belongs_to :tag
    belongs_to :event
end