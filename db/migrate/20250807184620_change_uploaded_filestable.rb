class ChangeUploadedFilestable < ActiveRecord::Migration[7.1]
  def change
    change_column_default :uploaded_files, :is_public, from: nil, to: false
    change_column_null :uploaded_files, :is_public, false
    
    add_index :uploaded_files, :public_share_token, unique: true
  end
end
