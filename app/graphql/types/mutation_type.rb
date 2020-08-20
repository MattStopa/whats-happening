module Types
  class MutationType < Types::BaseObject
    field :create_post, mutation: Mutations::CreatePost
    # TODO: remove me
    field :create_bucket, mutation: Mutations::CreateBucket
    field :delete_bucket, mutation: Mutations::DeleteBucket

  end
end
