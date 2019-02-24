class EventsController < ApplicationController
    protect_from_forgery except: :create
    def index
        render json: Event.all
    end

    def create
        terms = JSON.parse(request.raw_post)['event']
        terms = check_tags_and_create(terms)
        event = Event.new(terms)
        event.save
    end

    def update
        terms = JSON.parse(request.raw_post)['event']
        event = Event.find(terms.delete('id'))
        # event.tags_into_db_tags(terms.delete('tags'))
        terms = check_tags_and_create(terms)

        event.update(terms)
        event.save
    end
end
