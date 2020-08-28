module Types
  class EventType < Types::BaseObject
    field :id, ID, null: false

    field :task_number, Integer, null: true
    field :color, String, null: true
    field :task_size, Integer, null: true

    field :title, String, null: true
    field :status, String, null: true
    field :description, String, null: true
    field :date_finished, String, null: true

    field :json_description, String, null: true

    field :estimate_hour, Integer, null: true
    field :estimate_minute, Integer, null: true
    field :time_took_hour, Integer, null: true
    field :time_took_minute, Integer, null: true

    field :active, Boolean, null: true
    field :clock_start, String, null: true
    field :minutes_taken, Integer, null: true

    field :created_at, String, null: true

    def json_description
      object.json_description.to_json
    end
  end
end