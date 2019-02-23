class EventsController < ApplicationController
    protect_from_forgery except: :create
    def index
        render json: Event.all
    end

    def create
        terms = JSON.parse(request.raw_post)['event']
        event = Event.new(terms)
        event.save
    end

    def update
        terms = JSON.parse(request.raw_post)['event']
        event = Event.find(terms.delete('id'))
        event.update(terms)
        event.save
    end
end