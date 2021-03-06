module Conekta
  module Operations
    module CustomAction
      def custom_action(method, action=nil, params=nil)
        requestor = Requestor.new
        if action
          url = self.url + "/" + action
        else
          url = self.url
        end
        response = requestor.request(method, url, params)
        self.load_from(response)
        self
      end
    end
  end
end
