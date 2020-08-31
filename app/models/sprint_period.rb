class SprintPeriod
    include Mongoid::Document
    include Mongoid::Timestamps  

    field :period_start, type: Date

    has_many :events
    # Event.where(:scrum_period_start.gte => Date.today.beginning_of_week).and(:scrum_period_start.lte => 30.days.from_now.end_of_week)
end