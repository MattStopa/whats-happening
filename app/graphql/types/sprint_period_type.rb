module Types
    class SprintPeriodType < Types::BaseObject
      field :id, ID, null: false
      field :period_start, String, null: false
      field :events, [Types::EventType], null: true
    end
  end