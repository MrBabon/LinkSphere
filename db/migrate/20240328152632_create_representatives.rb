class CreateRepresentatives < ActiveRecord::Migration[7.0]
  def change
    create_table :representatives do |t|
      t.references :exhibitor, null: false, foreign_key: true
      t.references :entreprise, null: false, foreign_key: true
      t.bigint :employee_id
      t.bigint :entrepreneur_id

      t.timestamps
    end
  end
end
