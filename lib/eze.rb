require "pathname"

require "eze/version"

module Eze
  class Error < StandardError; end

  def self.root
    path = File.expand_path("#{__dir__}/..")

    Pathname.new(path)
  end
end
