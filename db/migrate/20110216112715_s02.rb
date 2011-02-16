class S02 < ActiveRecord::Migration
  def self.up
    lmb = MMigration.migration_for_source("02")
    instance_eval &lmb
  end

  def self.down
  end
end
