class UploadedFilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_uploaded_file, only: [:show, :edit, :update, :destroy, :toggle_public]
  before_action :check_file_ownership, only: [:show, :edit, :update, :destroy, :toggle_public]

  def index
    @uploaded_files = current_user.uploaded_files.order(created_at: :desc)
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @uploaded_file }
    end
  end

  def new
    @uploaded_file = current_user.uploaded_files.build
  end

  def create
    @uploaded_file = current_user.uploaded_files.build(uploaded_file_params)

    if @uploaded_file.save
      # Process file in background if needed (compression, virus scanning, etc.)
      ProcessFileJob.perform_later(@uploaded_file) if defined?(ProcessFileJob)
      
      redirect_to uploaded_files_path, notice: 'File was successfully uploaded.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @uploaded_file.update(uploaded_file_params.except(:vault_file))
      redirect_to @uploaded_file, notice: 'File details were successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @uploaded_file.destroy
    redirect_to uploaded_files_path, notice: 'File was successfully deleted.'
  end

  def download
    @uploaded_file = current_user.uploaded_files.find(params[:id])
    redirect_to rails_blob_path(@uploaded_file.vault_file, disposition: "attachment")
  end

  def toggle_public
    if @uploaded_file.is_public?
      @uploaded_file.make_private!
      message = 'File is now private.'
    else
      @uploaded_file.make_public!
      message = 'File is now public. Share URL: ' + @uploaded_file.public_share_url
    end

    respond_to do |format|
      format.html { redirect_to uploaded_files_path, notice: message }
      format.json { render json: { status: 'success', message: message, public_url: @uploaded_file.public_share_url } }
    end
  end

  private

  def set_uploaded_file
    @uploaded_file = UploadedFile.find(params[:id])
  end

  def check_file_ownership
    unless @uploaded_file.user == current_user
      redirect_to uploaded_files_path, alert: 'Access denied.'
    end
  end

  def uploaded_file_params
    params.require(:uploaded_file).permit(:title, :description, :vault_file)
  end
end