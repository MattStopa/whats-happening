class Event < ActiveRecord::Base
    # def as_json(options)
    #     items = super
    #     if(items["event_occured"]) 
    #         items["event_occured"] = items["event_occured"].strftime("%a %b %d %Y")
    #     end
    #     items
    # end    
end