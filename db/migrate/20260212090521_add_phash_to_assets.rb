class AddPhashToAssets < ActiveRecord::Migration[8.1]
  def change
    add_column :assets, :phash, :string
  end
end
