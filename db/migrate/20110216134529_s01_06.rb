class S0106 < ActiveRecord::Migration
  def self.up
    instance_eval(&MMigration.migration_for_source("01"))
    instance_eval(&MMigration.migration_for_source("02"))
    instance_eval(&MMigration.migration_for_source("03"))
    instance_eval(&MMigration.migration_for_source("04"))
    instance_eval(&MMigration.migration_for_source("05"))
    instance_eval(&MMigration.migration_for_source("06"))
  end

  def self.down
  end
end
