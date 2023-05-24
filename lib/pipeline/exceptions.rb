
module Pipeline::Exceptions
  class BadRequestError < StandardError; end
  class NotAuthorizedError < StandardError; end
  class PermissionDeinedError < StandardError; end
  class RecordNotFoundError < StandardError; end
  class NotAcceptableError < StandardError; end
  class TooManyRequestsError < StandardError; end
  class ApiError < StandardError
    attr_reader :code
    def initialize(message, code)
      @code = code
      super(message)
    end
  end
end
