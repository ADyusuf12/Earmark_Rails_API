class CreateEnquiries < ActiveRecord::Migration[8.0]
  def change
    create_table :enquiries do |t|
      t.references :user, null: false, foreign_key: true
      t.references :listing, null: false, foreign_key: true
      t.text :message, null: false
      t.timestamps
    end
  end
end
