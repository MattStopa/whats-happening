class Event < ActiveRecord::Base
    has_many :tag_list, :class_name => 'TagsList'
    has_many :tags, :class_name => 'Tag', through: :tag_list

    def as_json(options)
        super.merge({tags: tags})
    end
end