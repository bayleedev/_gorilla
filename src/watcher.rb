# Ick, this is kinda gross.
# Wishing Class#inherited had an 'after' filter.
class Object

  def self.singleton_method_added(method_name)
    Gorilla::Patcher.instance.run!
  end

  def self.inherited(klass_name)
    Gorilla::Patcher.instance.run!
  end

  def self.method_added(method_name)
    Gorilla::Patcher.instance.run!
  end

end

class Module

  def included(klass_name)
    Gorilla::Patcher.instance.run!
  end

  def extended(klass_name)
    Gorilla::Patcher.instance.run!
  end

end
