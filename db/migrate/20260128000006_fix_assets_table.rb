class FixAssetsTable < ActiveRecord::Migration[8.0]
  def change
    # Remove not-null constraint from user_id
    change_column_null :assets, :user_id, true
  end
end
