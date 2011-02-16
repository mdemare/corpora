class CreateTokens < ActiveRecord::Migration
  def self.up
    instance_eval(&MMigration.migration_for_source("02"))
  end

  def self.down
    drop_table "tokens_#{source}".to_sym
    drop_table "g3_#{source}".to_sym
    drop_table "s3g_#{source}".to_sym
  end
end
