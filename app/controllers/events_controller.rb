class EventsController < ApplicationController
    protect_from_forgery except: :create
    def index
        render json: Event.all 
    end

    def for_bucket
        data = Bucket.find(params[:id]).events

        statuses = []
        statuses.push('done') if params[:fil_closed] == "true"
        statuses.push('open') if params[:fil_open] == "true"
        statuses.push(nil) if params[:fil_open] == "true"

        data = data.in(status: statuses)

        if params[:byDate]
            data = Bucket.find(params[:id]).events.where(status: :'done').order_by(date_finished: :desc)
        elsif params[:sort] 
            data = data.order_by(params[:sort] => params[:direction])
        else
            data
        end

        render json: data
    end

    def generate_chart
        data = nil
        if params[:type] == 'bar'
            data = ChartBuilder.gen_bar_chart( params[:id], params[:days].to_i, params[:type])
        elsif params[:type] == 'burn'
            data = ChartBuilder.gen_burn_chart( params[:id], params[:days].to_i, params[:type])
        elsif params[:type] == 'build'
            data = ChartBuilder.gen_build_chart( params[:id], params[:days].to_i, params[:type])
        end
        render json: data
    end

    
    def create
        terms = JSON.parse(request.raw_post)['event']
        bucket = terms.delete("bucket")
        event = Event.new(terms)
        event.bucket = bucket['_id']['$oid']
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
