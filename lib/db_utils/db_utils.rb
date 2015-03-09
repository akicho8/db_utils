# -*- coding: utf-8 -*-
require "rain_table"
require "pathname"
require "erb"
require "yaml"
require "pp"
require "active_record"

module DbUtils
  # DBの情報表示
  #
  # $ db
  #
  class DbShow
    class << self
      def list
        list = []

        file = Pathname("config/database.yml")
        if file.exist?
          db_hash = YAML.load(ERB.new(file.read).result(binding))
          db_hash = db_hash.except("defaults")
          list += db_hash.values
        end

        file = Pathname("config/shards.yml")
        if file.exist?
          shards_hash = YAML.load(ERB.new(file.read).result(binding))
          octopus = shards_hash["octopus"]
          list += octopus.slice(*octopus["environments"]).flat_map {|env, blue_green| blue_green.values }
        end

        file = Pathname("config/ridgepole.yml")
        if file.exist?
          ridgepole_hash = YAML.load(ERB.new(file.read).result(binding))
          list += ridgepole_hash["numbering"].values
        end

        # list = list.reject{|e|e["database"].include?("production")}

        list
      end
    end

    def run
      rows = self.class.list.collect do |params|
        {
          "名前"    => params["database"],
          "接"      => active?(params),
          "テ"      => table_count(params),
          "migrate" => migrator_current_version(params),
          "host"    => params["host"],
        }
      end

      puts RainTable.generate(rows)
    end

    def active?(params)
      ActiveRecord::Base.establish_connection(params)
      if ActiveRecord::Base.connection.active?
        "OK"
      end
    rescue
    end

    def table_count(params)
      ActiveRecord::Base.establish_connection(params)
      ActiveRecord::Base.connection.tables.count
    rescue
    end

    def migrator_current_version(params)
      ActiveRecord::Base.establish_connection(params)
      ActiveRecord::Migrator.current_version
    rescue
    end
  end

  # 各DBのテーブル内レコード数簡易表示
  #
  # $ table
  # $ table development
  # $ table development profile
  # $ table development 'user|profile'
  #
  class TableShow
    def run(db_mask = nil, table_mask = nil)
      list = DbShow.list
      tables = []

      list.each do |e|
        begin
          ActiveRecord::Base.establish_connection(e)
          tables += ActiveRecord::Base.connection.tables
          tables.uniq!
        rescue
        end
      end

      if db_mask
        list = list.find_all {|e| e["database"].match(db_mask) }
      end

      if table_mask
        tables = tables.find_all {|e| e.match(table_mask) }
      end

      rows = tables.collect do |table|
        row = {}
        row[""] = table
        list.each do |config|
          begin
            ActiveRecord::Base.establish_connection(config)
            count = ActiveRecord::Base.connection.select_value("SELECT COUNT(*) FROM #{table}")
            row[config["database"].sub(/\A\w+?_/, "").sub(/development/, "dev")] = count
          rescue
          end
        end
        row
      end

      puts RainTable.generate(rows)
    end
  end
end
