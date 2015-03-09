# -*- coding: utf-8 -*-
require "bundler/setup"
require "db_utils"
Dir.chdir("#{__dir__}/../test/myapp") do
  DbUtils::DbShow.new.run
  DbUtils::TableShow.new.run
end
