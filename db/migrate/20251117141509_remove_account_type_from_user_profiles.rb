class RemoveAccountTypeFromUserProfiles < ActiveRecord::Migration[8.0]
  def change
    remove_column :user_profiles, :account_type, :string
  end
end
