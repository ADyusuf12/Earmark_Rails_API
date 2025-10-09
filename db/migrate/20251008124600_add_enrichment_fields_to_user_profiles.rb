class AddEnrichmentFieldsToUserProfiles < ActiveRecord::Migration[8.0]
  def change
    add_column :user_profiles, :phone_number, :string
    add_column :user_profiles, :bio, :text
  end
end
