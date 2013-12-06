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

end
