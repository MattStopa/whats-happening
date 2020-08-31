module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.


    field :user, Types::UserType, null: false do
      argument :id, ID, {required: false}
      description "Current User"
    end

    # bucket(id: "${id}", sort: "${data.sortKey}", direction: "${data.direction}", filClosed: "${data.filters.finished}", filOpen: "${data.filters.open}") {

    field :events, [Types::EventType], null: false do
      argument :id, ID, {required: false}
      argument :sort, String, {required: false}
      argument :direction, String, {required: false}
      argument :filClosed, Boolean, {required: false}
      argument :filOpen, Boolean, {required: false}
      argument :byDate, String, {required: false}
      argument :timeline, Boolean, {required: false}
      description "These are the users buckets"
    end

    field :event, Types::EventType, null: false do
      argument :id, ID, {required: false}
   
      description "1 user event"
    end

    field :bucket, [Types::BucketType], null: false do
      description "These are the users buckets"
    end

    field :me, Types::UserType, null: false do
      description "The current user"
    end

    field :sprints, [Types::SprintPeriodType], null: false do
      description "This is the list of sprints and their events"
    end

    def event(params)
      Event.find(params[:id])
    end

    def sprints
      SprintPeriod.all
    end

    def me
      User.first
    end

    def bucket
      Bucket.where(:status.ne => "deleted")
    end

    def events(params)
      if(params[:id]) 
        data = Bucket.find(params[:id]).events

        statuses = []
        statuses.push('done') if params[:filClosed] == true
        statuses.push('open') if params[:filOpen] == true
        statuses.push(nil) if params[:filOpen] == true
  
        data = data.in(status: statuses)

        if params[:byDate] == "true"
          data = Bucket.find(params[:id]).events.order_by(date_finished: :desc)
        elsif params[:sort] 
          data = data.order_by(params[:sort] => params[:direction])
        elsif params[:timeline]
          # data = Event
          #           .where(:scrum_period_start.gte => Date.today
          #           .beginning_of_week)
          #           .and(:scrum_period_start.lte => 30.days.from_now.end_of_week)
        else
            data
        end
        data.all
      end
    end
  end

end
