module Context
  def context
    @context ||= Context.new
  end

  def clear_context
    @context = nil
  end

  class Context

    def initialize
      @data = {}
    end

    def [](key)
      result = @data[key]
      if result.nil?
        raise "nothing called #{key} was set up in the context - you should do this in a previous step"
      end
      result
    end

    def []=(key, value)
      if value.nil?
        raise "you tried to set nil into the context for #{key}"
      end
      @data[key] = value
    end

    def has_key?(key)
      @data.has_key? key
    end

  end

end