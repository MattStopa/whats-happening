module Mutations
  class CreateBucket < BaseMutation
    type Types::BucketType

    argument :id, ID, required: false
    argument :name, String, required: false
    argument :userID, String, required: true

    def resolve(args)
      user = User.find(args[:userID]).id

      if(args[:id])
        b = Bucket.find(args[:id])
        b.update(name: args[:name])
        b.save
        b
      else
        Bucket.create!(
          name: args[:name],
          user_id: user
        )
      end
    # rescue => e
    #   GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
    end
  end
end