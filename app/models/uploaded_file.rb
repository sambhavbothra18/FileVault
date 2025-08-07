class UploadedFile < ApplicationRecord
  belongs_to :user

  has_one_attached :vault_file

  validates :title, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 1000 }
  validates :vault_file, presence: true
  
  validate :acceptable_file_size
  validate :acceptable_file_type
  
  before_create :generate_public_share_token

  scope :public_files, -> { where(is_public: true) }
  scope :private_files, -> { where(is_public: false) }

  def file_type
    vault_file.attached? ? vault_file.content_type : nil
  end

  def file_size
    vault_file.attached? ? vault_file.byte_size : 0
  end

  def formatted_file_size
    return "0 B" unless vault_file.attached?
    
    size = vault_file.byte_size.to_f
    units = ['B', 'KB', 'MB', 'GB']
    
    units.each_with_index do |unit, index|
      return "#{size.round(2)} #{unit}" if size < 1024 || index == units.length - 1
      size /= 1024
    end
  end

  def filename
    vault_file.attached? ? vault_file.filename.to_s : nil
  end

  def public_share_url
    return nil unless is_public? && public_share_token.present?
    Rails.application.routes.url_helpers.public_file_url(
      public_share_token,
      host: Rails.application.routes.default_url_options[:host] || "localhost:3000"
    )
  end

  def make_public!
    update!(is_public: true)
    generate_public_share_token if public_share_token.blank?
    save!
  end

  def make_private!
    update!(is_public: false)
  end

  private

  def generate_public_share_token
    self.public_share_token = SecureRandom.urlsafe_base64(8)
  end

  def acceptable_file_size
    return unless vault_file.attached?

    if vault_file.byte_size > 1.gigabyte
      errors.add(:vault_file, "must be less than 1GB")
    end
  end

  def acceptable_file_type
    return unless vault_file.attached?

    # Block potentially dangerous file types
    dangerous_types = [
      'application/x-msdownload', # .exe
      'application/x-msdos-program', # .exe
      'application/x-executable', # various executables
      'application/x-shellscript', # shell scripts
      'text/x-shellscript' # shell scripts
    ]

    if dangerous_types.include?(vault_file.content_type)
      errors.add(:vault_file, "file type not allowed for security reasons")
    end
  end
end