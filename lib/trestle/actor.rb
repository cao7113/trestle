module Trestle
  class Actor
    attr_accessor :id, :opts

    def initialize(id, opts = {})
      @id, @opts = id.to_sym, opts || {}
    end

    def layout
      opts[:layout]
    end

    def admins
      self.class.admins_registry(id)
    end

    def scope 
      opts[:scope] || Object
    end

    def prefix
      opts[:prefix]
    end

    def namespace
      return unless prefix
      prefix.classify
    end

    def helpers_name
      "#{namespace}::AdminControllerMethods"
    end

    def helpers_defined?
      scope.const_defined?(helpers_name)
    end

    def helpers_const
      scope.const_get(helpers_name)
    end

    class << self 
      def registry
        Trestle.config.actors
      end

      def find(id)
        registry[id]
      end

      def admins_registry(id)
        Trestle.actors_admins[id.to_sym] ||= {}
      end
    end
  end
end