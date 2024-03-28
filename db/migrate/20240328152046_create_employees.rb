class CreateEmployees < ActiveRecord::Migration[7.0]
  def change
    create_table :employees do |t|
      t.references :user, null: false, foreign_key: true
      t.references :entreprise, null: false, foreign_key: true
      t.string :role

      t.timestamps
    end
  end
end
