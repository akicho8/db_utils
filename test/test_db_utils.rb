# -*- coding: utf-8 -*-
require 'test_helper'

Test::Unit.at_start do
  Dir.chdir("test/myapp") do
    Bundler.clean_system("bin/setup")
  end
end

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
