# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  has_many :articles, :dependent => :destroy

  def where_shard
    if id.odd?
      "blue"
    else
      "green"
    end
  end
end
