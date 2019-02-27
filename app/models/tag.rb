class Tag < ActiveRecord::Base
   
  def as_json
    {
        id: id,
        value: title
    }
  end
end