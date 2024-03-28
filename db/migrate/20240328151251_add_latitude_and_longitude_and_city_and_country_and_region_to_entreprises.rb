class AddLatitudeAndLongitudeAndCityAndCountryAndRegionToEntreprises < ActiveRecord::Migration[7.0]
  def change
    add_column :entreprises, :latitude, :float
    add_column :entreprises, :longitude, :float
    add_column :entreprises, :country, :string
    add_column :entreprises, :city, :string
    add_column :entreprises, :region, :string
  end
end
