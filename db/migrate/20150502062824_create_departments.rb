class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :name
      t.string :code
      t.string :location
      t.string :in_charge

      t.timestamps null: false
    end
  end
end
