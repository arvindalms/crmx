class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.references :organization

      t.timestamps
    end
  end
end
