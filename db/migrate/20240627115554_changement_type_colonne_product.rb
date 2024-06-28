class ChangementTypeColonneProduct < ActiveRecord::Migration[7.1]
  def change
    change_column :products, :price, :decimal
  end
end
