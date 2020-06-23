class Event
    include Mongoid::Document

    field :title, type: String
    field :status, type: String
    field :description, type: String
    field :date_finished, type: DateTime

    field :json_description, type: Hash

    field :estimate_hour, type: Integer
    field :estimate_minute, type: Integer
    field :time_took_hour, type:Integer
    field :time_took_minute, type:Integer
end