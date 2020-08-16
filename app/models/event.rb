class Event
    include Mongoid::Document
    include Mongoid::Timestamps  

    before_save :increase_bucket_count    
    before_save :assign_color

    belongs_to :bucket

    field :task_number, type: Integer
    field :color, type: String
    field :task_size, type: Integer

    field :title, type: String
    field :status, type: String
    field :description, type: String
    field :date_finished, type: DateTime

    field :json_description, type: Hash

    field :estimate_hour, type: Integer
    field :estimate_minute, type: Integer
    field :time_took_hour, type:Integer
    field :time_took_minute, type:Integer

    field :active, type: Boolean
    field :clock_start, type: String
    field :minutes_taken, type: Integer



    def increase_bucket_count
      unless self.task_number
        self.task_number = self.bucket.increase_bucket_count
      end
    end

    def assign_color
      self.color = %w(first second third fourth fifth sixth seventh eighth ninth tenth).sample unless self.color
    end
end