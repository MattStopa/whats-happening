module Mutations
  class CreatePost < BaseMutation
    # TODO: define return fields
    field :post, Types::PostType, null: false

    argument :name, String, required: true

    def resolve(name:)
      raise "GOT EHRE"
    end
  end
end
