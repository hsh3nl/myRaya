class User < ApplicationRecord
    # AR Associations
    has_many :events
    has_many :bookings
    
    # Bcrypt
    has_secure_password

    # Photo uploader
    mount_uploader :image, ProfileUploader

    # User roles
    enum role: { master: 0, moderator: 1, customer: 2 }

    # AR Validations
    validates :first_name, :last_name, :gender, :tel_no, presence: true
    validates :email, presence: true, uniqueness: true, format: { with: /([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})/, message: "only alphabets, numbers, dash or underscores" }
    validates :image, file_size: { less_than: 1.megabytes }

end
