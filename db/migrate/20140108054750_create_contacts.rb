class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :f1
      t.string :f2
      t.string :f3
      t.string :f4
      t.string :f5
      t.string :f6
      t.string :f7
      t.string :f8
      t.string :f9
      t.string :f10
      t.belongs_to :group
      t.timestamps
    end
  end
end
