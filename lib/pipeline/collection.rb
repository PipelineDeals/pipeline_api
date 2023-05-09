module Pipeline
  class Collection < ActiveResource::Collection
    attr_accessor :pagination
    def initialize(parsed = {})
      if parsed.is_a?(Hash)
        @pagination = HashWithIndifferentAccess.new(parsed["pagination"])
        @elements = parsed["entries"]
      else
        @elements = parsed
      end
    end
  end
end
