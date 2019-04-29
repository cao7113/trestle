module Trestle
  module Controller
    module Layout
      extend ActiveSupport::Concern

      included do
        layout :choose_layout
      end

    protected
      def choose_layout
        # request.xhr? ? false : "trestle/admin"

        return false if request.xhr?
        if actor = admin.find_actor
          return actor.layout if actor.layout
        end
        "trestle/admin"
      end
    end
  end
end
