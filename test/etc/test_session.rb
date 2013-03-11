require "fileutils"
require "#{File.dirname(__FILE__)}/test/test_helper"

module GuineaPig
  module Experiments
    def self.experiments_path
      "#{File.dirname(__FILE__)}/test/fixtures/ab_experiments.yml"
    end
  end
end

user = User.create!
ab_test = GuineaPig.get(:experiment_monkey, user)