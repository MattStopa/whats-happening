module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"

    field :user, Types::UserType, null: false do
      argument :id, ID, {required: false}
      description "Current User"
    end

    # bucket(id: "${id}", sort: "${data.sortKey}", direction: "${data.direction}", filClosed: "${data.filters.finished}", filOpen: "${data.filters.open}") {

    field :event, [Types::EventType], null: false do
      argument :id, ID, {required: false}
      argument :sort, String, {required: false}
      argument :direction, String, {required: false}
      argument :filClosed, String, {required: false}
      argument :filOpen, ID, {required: false}
      description "These are the users buckets"
    end

    field :bucket, [Types::BucketType], null: false do
   
      description "These are the users buckets"
    end

    def test_field
      "obj.inspect"
    end

    def user(id)
      User.find(id)
    end

    def bucket
      Bucket.all
    end

    def event(params)
      if(params[:id]) 
        data = Bucket.find(params[:id]).events


        statuses = []
        statuses.push('done') if params[:filClosed] == "true"
        statuses.push('not done') if params[:filOpen] == "true"
        statuses.push(nil) if params[:filOpen] == "true"
  
        data = data.in(status: statuses)
  
        if params[:byDate]
            data = Bucket.find(params[:id]).events.where(status: :'done').order_by(date_finished: :desc)
        elsif params[:sort] 
            data = data.order_by(params[:sort] => params[:direction])
        else
            data
        end
        

        data.all
      end
    end
  end

end
