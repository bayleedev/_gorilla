# Compiled version
module Gorilla

  class Counter

    attr_accessor :counter

    def initialize
      self.counter = 0
    end

    def plusplus
      self.counter = counter + 1
    end

    def to_s
      counter.to_s
    end

  end

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

  class Signature

    SPLIT = /#|\./

    def initialize(signature)
      @signature = signature
    end

    def klass
      @klass_name = @signature.split(SPLIT)[0].split('::')
      @klass ||= @klass_name.inject(Object) do |memo, word|
        memo.const_get(word)
      end
    rescue NameError
      return false
    end

    def method
      @method ||= @signature.split(SPLIT)[1].to_sym
    end

    def to_s
      @signature
    end

    # Won't cache `false`, should use `memoize`, but meh.
    def instance_method?
      @instance_method ||= !!@signature.match(/#/)
    end

    # Sure, it's actually a `class_method?` but `class`
    # and `instance` aren't really opposites.
    def static_method?
      !instance_method?
    end

    def exists?
      klass_exists? && method_exists?
    end

    def current_method
      return false unless klass_exists?
      if instance_method?
        klass.instance_method(method)
      else
        klass.method(method)
      end
    end

    def matches?(signature)
      @signature == signature
    end

    def klass_exists?
      klass.is_a?(Class)
    end

    def method_exists?
      return false unless klass_exists?
      if instance_method?
        klass.instance_methods.include?(method)
      else
        klass.methods.include?(method)
      end
    end

  end

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

    def initialize(options)
      @written = false
      @signature = options.delete(:signature)
      @counter = options.delete(:counter) || Counter.new
      if @signature.instance_method?
        extend InstancePatcher
      else
        extend StaticPatcher
      end
    end

    def run!
      patch_method if needs_patch?
    end

    def patch_method
      @patched = true
      overwrite_method(@signature) do
        @counter.plusplus
      end
    end

    def needs_patch?
      @signature.exists? && !@patched
    end

  end


end

class Object

  def self.singleton_method_added(method_name)
    Gorilla::Runner.run!
  end

  def self.inherited(klass_name)
    Gorilla::Runner.run!
  end

  def self.method_added(method_name)
    Gorilla::Runner.run!
  end

end

class Module

  def included(klass_name)
    Gorilla::Runner.run!
  end

  def extended(klass_name)
    Gorilla::Runner.run!
  end

end
