class AddNamesToUserProfiles < ActiveRecord::Migration[8.0]
  def change
    add_column :user_profiles, :first_name, :string
    add_column :user_profiles, :last_name, :string
  end
end
