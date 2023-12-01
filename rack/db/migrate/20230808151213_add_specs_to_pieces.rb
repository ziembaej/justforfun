class AddSpecsToPieces < ActiveRecord::Migration[7.0]
  def change
    add_column :pieces, :brand, :string
    add_column :pieces, :model, :string
    add_column :pieces, :purchase_date, :date
    add_column :pieces, :purchase_price, :decimal, :precision => 8, :scale => 2
    add_column :pieces, :purchase_location, :string
    add_column :pieces, :serial_number, :string
    add_column :pieces, :retired_on, :date
  end
end
