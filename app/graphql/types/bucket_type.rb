module Types
  class BucketType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :count, Int, null: false
    field :events, [Types::EventType], null: true
  end
end