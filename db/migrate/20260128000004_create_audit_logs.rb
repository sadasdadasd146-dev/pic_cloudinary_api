class CreateAuditLogs < ActiveRecord::Migration[8.0]
  def change
    unless table_exists?(:audit_logs)
      create_table :audit_logs do |t|
        t.references :user, null: true, foreign_key: true
        t.string :action
        t.string :resource_type
        t.integer :resource_id
        t.text :changes
        t.string :ip_address
        t.timestamps
      end
      
      add_index :audit_logs, [:resource_type, :resource_id]
      add_index :audit_logs, :created_at
    else
      # Add missing columns if table exists
      add_column :audit_logs, :user_id, :bigint, if_not_exists: true
      add_column :audit_logs, :action, :string, if_not_exists: true
      add_column :audit_logs, :resource_type, :string, if_not_exists: true
      add_column :audit_logs, :resource_id, :integer, if_not_exists: true
      add_column :audit_logs, :changes, :text, if_not_exists: true
      add_column :audit_logs, :ip_address, :string, if_not_exists: true
      
      add_foreign_key :audit_logs, :users, if_not_exists: true
      add_index :audit_logs, [:resource_type, :resource_id], if_not_exists: true
      add_index :audit_logs, :created_at, if_not_exists: true
    end
  end
end
