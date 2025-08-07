class PublicFilesController < ApplicationController
  skip_before_action :authenticate_user!
  
  def show
    @uploaded_file = UploadedFile.find_by!(public_share_token: params[:token], is_public: true)
    
    respond_to do |format|
      format.html
      format.json { render json: @uploaded_file.as_json(except: [:user_id]) }
    end
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { render 'errors/not_found', status: :not_found }
      format.json { render json: { error: 'File not found or not public' }, status: :not_found }
    end
  end

  def download
    @uploaded_file = UploadedFile.find_by!(public_share_token: params[:token], is_public: true)
    redirect_to rails_blob_path(@uploaded_file.vault_file, disposition: "attachment")
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'File not found or not available for public download.'
  end
end