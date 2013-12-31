module Conekta
  class Error < Exception
    attr_reader :message
    attr_reader :type
    attr_reader :code
    attr_reader :param

    def initialize(message=nil, type=nil, code=nil, param=nil)
      @message = message
      @type = type
      @code = code
      @param = param
    end
    def self.error_handler(resp, code)
      if resp.instance_of?(Hash)
        @message = resp["message"] if resp.has_key?('message')
        @type = resp["type"] if resp.has_key?('type')
        @code = resp["code"] if resp.has_key?('code')
        @param = resp["param"] if resp.has_key?('param')
      end
      if code == nil or code == 0
        raise NoConnectionError.new("Could not connect to #{Conekta.api_base}", @type, @code, @param)
      end
      case code
      when 400
				raise MalformedRequestError.new(@message, @type, @code, @params)
			when 401
				raise AuthenticationError.new(@message, @type, @code, @params)
			when 402
				raise ProcessingError.new(@message, @type, @code, @params)
			when 404
				raise ResourceNotFoundError.new(@message, @type, @code, @params)
			when 422
				raise ParameterValidationError.new(@message, @type, @code, @params)
			when 500
				raise ApiError.new(@message, @type, @code, @params)
			else
				raise Error.new(@message, @type, @code, @params)
      end
    end
  end
  class ApiError < Error		
	end
	
	class NoConnectionError < Error 
	end

	class AuthenticationError < Error 
	end

	class ParameterValidationError < Error 
	end

	class ProcessingError < Error 
	end

	class ResourceNotFoundError < Error 
	end

	class MalformedRequestError < Error 
	end
end