class Event < ActiveRecord::Base
    has_many :tag_list, :class_name => 'TagsList'
    has_many :tags, :class_name => 'Tag', through: :tag_list

    def as_json(options)
        event_date = Date.new
        if(occurance_year) 
            event_date = Date.new(occurance_year, occurance_month, occurance_day + 1)
        end 

        super.merge({
            tags: tags,
            event_occured: event_date,
            event_date_display: event_date.strftime("%b %d, %Y")
         })
    end
end