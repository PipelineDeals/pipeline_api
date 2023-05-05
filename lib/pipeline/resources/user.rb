module Pipeline
  class User < Pipeline::Resource
    has_many :deals, class_name: "Pipeline::Deal"
    has_many :people, class_name: "Pipeline::Person"
  end
end

