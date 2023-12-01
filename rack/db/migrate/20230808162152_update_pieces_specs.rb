class UpdatePiecesSpecs < ActiveRecord::Migration[7.0]
  def change
    change_column :pieces, :brand, :string
    change_column :pieces, :model, :string
    change_column :pieces, :purchase_date, :date
  end
end
