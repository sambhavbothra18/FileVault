class AddPublicSharingToUploadedFiles < ActiveRecord::Migration[7.1]
  def change
    add_column :uploaded_files, :public_share_token, :string
    add_column :uploaded_files, :is_public, :boolean, default: false
    
    add_index :uploaded_files, :public_share_token, unique: true
  end
end