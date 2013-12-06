# The monkey (Gorilla) patching module helps to count, existing or
# new, method calls.
module Gorilla

  class Runner

    # Singleton... ick!
    def self.run!
      @instance ||= new(ENV)
      @instance.run!
      @instance
    end

    def initialize(env)
      @signature = Signature.new(env['COUNT_CALLS_TO'] || 'String.name')
      @counter = Counter.new
      @patcher = Patcher.new(signature: @signature, counter: @counter)
      at_exit { p self.finalize }
    end

    def run!
      @patcher.run!
    end

    def finalize
      "#{@signature} called #{@counter} times"
    end

  end

end
