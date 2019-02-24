class Event < ActiveRecord::Base
    has_many :tag_list, :class_name => 'TagsList'
    has_many :tags, :class_name => 'Tag', through: :tag_list

    # def tags_to_db_tags(tags)
    #     tags.each do |tag|
    #     if(!tag['id']) 
    #         db_tag = Tag.where(title: tag['value']).first
    #         if(!db_tag) 
    #             new_tag = Tag.create(title: tag['value'], description: "")
    #             new_tag.save
    #             tag['id'] = new_tag.id
    #         else
    #         tag['id'] = db_tag.id
    #         end
    #     end
    # end
end