module Gorilla

  module InstancePatcher
    # Overwrite instance methods
    def overwrite_method(signature, &block)
      old_method = signature.current_method
      signature.klass.class_eval do
        define_method(signature.method) do |*args|
          block.call if signature.matches?("#{self.class}##{__method__}")
          old_method.bind(self).call(*args)
        end
      end
    end
  end

  module StaticPatcher
    # Overwrite Static (class object) methods
    def overwrite_method(signature, &block)
      old_method = signature.current_method
      signature.klass.define_singleton_method(signature.method) do |*args|
        block.call if signature.matches?("#{self}.#{__method__}")
        old_method.call(*args)
      end
    end
  end

  # In charge of patching new static methods and setting up a watcher
  # for future patches
  class Patcher
    attr_accessor :patched

    class << self
      protected :new, :clone, :dup
    end

    def self.instance
      @instance ||= new
    end

    def count_calls_to
      ENV['COUNT_CALLS_TO'] || 'String.name'
    end

    # TODO fix large method
    def initialize
      @written = false
      @signature = Signature.new(count_calls_to)
      @counter = Counter.new
      if @signature.instance_method?
        extend InstancePatcher
      else
        extend StaticPatcher
      end
      at_exit { p self.finalize }
    end

    def finalize
      "#{@signature} called #{@counter} times"
    end

    def run!
      patch_method if needs_patch?
    end

    def patch_method
      @patched = true
      overwrite_method(@signature) do
        @counter.plusplus
      end end

    def needs_patch?
      @signature.exists? && !@patched
    end

  end

end
