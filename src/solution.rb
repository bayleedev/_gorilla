require 'pry'
# Class to File ratio 1:1
# ... is my PHP showing?
dir = File.dirname(__FILE__)
require "#{dir}/counter.rb"
require "#{dir}/patcher.rb"
require "#{dir}/signature.rb"
require "#{dir}/watcher.rb"

Gorilla::Patcher.instance.run!
