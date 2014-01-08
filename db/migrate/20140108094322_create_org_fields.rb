class CreateOrgFields < ActiveRecord::Migration
  def change
    create_table :org_fields do |t|
      t.string :name
      t.string :data_type
      t.string :field_no
      t.belongs_to :organization

      t.timestamps
    end
  end
end
