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
end