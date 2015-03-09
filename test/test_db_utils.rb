# -*- coding: utf-8 -*-
require 'test_helper'

class TestDbUtils < Test::Unit::TestCase
  test "DbShow" do
    Dir.chdir("test/myapp") do
      DbUtils::DbShow.new.run
    end
  end

  test "TableShow" do
    Dir.chdir("test/myapp") do
      DbUtils::TableShow.new.run
      DbUtils::TableShow.new.run("development", "users")
    end
  end
end
