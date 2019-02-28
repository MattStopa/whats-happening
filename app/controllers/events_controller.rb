class EventsController < ApplicationController
    protect_from_forgery except: :create
    def index
        render json: Event.where.
                        not(occurance_year: nil).
                        includes(:tags).
                        order(occurance_year: :asc).all
    end

    def by_tag

        tag = Tag.where(title: params['tag']).first

        if(tag)
            render json: tag.events.order(occurance_year: :asc).where.not(occurance_year: nil)
        else 
            render json: []
        end
    end

    def create
        terms = JSON.parse(request.raw_post)['event']
        tags = check_tags_and_create(terms.delete('tags'))
        occured = Date.parse(terms.delete('event_occured'))
        event = Event.new(terms)

        event.occurance_year = occured.year
        event.occurance_day = occured.day
        event.occurance_month = occured.month
        event.tags = tags
        event.save
    end

    def update
        terms = JSON.parse(request.raw_post)['event']
        event = Event.find(terms.delete('id'))
        event.tags = check_tags_and_create(terms.delete('tags'))
        occured = Date.parse(terms.delete('event_occured'))
        terms.delete('event_date_display')
        event.update(terms)
            
        event.occurance_year = occured.year
        event.occurance_day = occured.day
        event.occurance_month = occured.month

        event.save
    end

    private 

        def check_tags_and_create(terms)
            terms.map do |tag|
                if(tag['id']) 
                    Tag.find(tag['id'].to_i)
                else
                    existing_tag = Tag.where(title: tag['value']).first
                    if(existing_tag) 
                        existing_tag
                    else
                        new_tag = Tag.create(title: tag['value'], description: "")
                        new_tag.save
                        new_tag
                    end
                end
            end
        end
end
