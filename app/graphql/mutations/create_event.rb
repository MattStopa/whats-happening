module Mutations
  class CreateEvent < BaseMutation
    type Types::EventType
    argument :userID, ID, required: true
    argument :id, ID, required: false
    argument :task_size, Integer, required: false
    argument :title, String, required: true
    argument :status, String, required: false
    argument :description, String, required: false
    argument :date_finished, String, required: false

    argument :json_description, String, required: false

    argument :estimate_hour, Integer, required: false
    argument :estimate_minute, Integer, required: false
    argument :time_took_hour, Integer, required: false
    argument :time_took_minute, Integer, required: false

    argument :active, Boolean, required: false
    argument :clock_start, String, required: false
    argument :minutes_taken, Integer, required: false

    def resolve(args)
      a = args.except(:userID)
      a[:json_description] = JSON.parse(URI.decode(args[:json_description]))

      event = Event.find(args[:id])
      event.update(a)
      event.save

      event
      # if(args[:id])
      #   b = Bucket.find(args[:id])
      #   b.update(name: args[:name])
      #   b.save
      #   b
      # else
      #   Bucket.create!(
      #     name: args[:name],
      #     user_id: user
      #   )
      # end
    # rescue => e
    #   GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
    end
  end
end