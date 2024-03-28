class ChangeAddressToStringInEntreprises < ActiveRecord::Migration[7.0]
  def change
    change_column :entreprises, :address, :string
  end
end
