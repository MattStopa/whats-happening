class EventsController < ApplicationController
    protect_from_forgery except: :create
    def index
        render json: Event.all 
    end

    def for_bucket
        render json: Bucket.find(params[:id]).events
    end

    def create
        terms = JSON.parse(request.raw_post)['event']
        event = Event.new(terms)
        event.save
    end

    def update
        terms = JSON.parse(request.raw_post)['event']
        event = Event.find(terms.delete('_id')['$oid'])
        event.update(terms)
        event.save
    end

    def destroy 
        event = Event.find(params[:id])
        render json: {"status": "success"} if event.destroy
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
