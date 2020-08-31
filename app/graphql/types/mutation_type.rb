module Types
  class MutationType < Types::BaseObject
    field :create_post, mutation: Mutations::CreatePost
    # TODO: remove me
    field :create_bucket, mutation: Mutations::CreateBucket
    field :delete_bucket, mutation: Mutations::DeleteBucket

    field :create_event, mutation: Mutations::CreateEvent
    field :save_task_to_sprint, mutation: Mutations::SaveTaskToSprint

  end
end
