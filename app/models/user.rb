class User < ApplicationRecord
    has_secure_password
    has_many :events

    validates :first_name, :last_name, presence: true
    validates :email, presence: true, uniqueness: true, format: { with: /([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})/,
    message: "only alphabets, numbers, dash or underscores" }

end
