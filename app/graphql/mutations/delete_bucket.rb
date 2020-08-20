module Mutations
  class DeleteBucket < BaseMutation
    type Types::BucketType

    argument :id, ID, required: false
    argument :userID, String, required: true

    def resolve(args)
      b = Bucket.find(args[:id])
      b.update(status: 'deleted')
      b.save
      b
    end
  end
end