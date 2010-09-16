class CreateProjectsProfiles < ActiveRecord::Migration
  def self.up
    create_table :projects_profiles do |t|
      t.column :meaning, :string
      t.column :value, :string
    end
  end

  def self.down
    drop_table :projects_profiles
  end
end
