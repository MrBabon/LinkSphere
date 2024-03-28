class CreateEntreprises < ActiveRecord::Migration[7.0]
  def change
    create_table :entreprises do |t|
      t.string :name
      t.string :email
      t.string :website
      t.string :linkedin
      t.string :instagram
      t.string :facebook
      t.string :twitter
      t.string :headline
      t.string :industry
      t.text :description
      t.string :siret_number
      t.string :tva_number
      t.text :address
      t.string :phone_number
      t.datetime :establishment_date
      t.string :legal_status

      t.timestamps
    end
  end
end
