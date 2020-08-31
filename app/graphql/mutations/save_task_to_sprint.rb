module Mutations
  class SaveTaskToSprint < BaseMutation
    type [Types::SprintPeriodType]

    argument :sprintID, ID, required: true
    argument :taskID, ID, required: true

    def resolve(args)
      s = SprintPeriod.find(args[:sprintID])
      s.events << Event.find(args[:taskID])
      s.save
      SprintPeriod.all
    end
  end
end