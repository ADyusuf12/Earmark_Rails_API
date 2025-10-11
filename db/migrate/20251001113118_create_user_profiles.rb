class CreateUserProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :user_profiles do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.string :account_type, null: false, default: "customer"

      t.timestamps
    end

    add_index :user_profiles, :account_type
  end
end
