module Gorilla

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

end
