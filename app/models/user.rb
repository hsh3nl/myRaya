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
    validates :first_name, :last_name, :gender, presence: true
    validates :tel_no, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true, format: { with: /([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})/, message: "only alphabets, numbers, dash or underscores" }
    validates :image, file_size: { less_than: 1.megabytes }

    # Analytics
    def self.analytics(period_in_days)
        user_signups_since = 0
        customer_count_all = 0
        moderator_count_all = 0
        master_count_all = 0

        User.all.each do |u|
            if u.created_at > Date.today - period_in_days.day
                user_signups_since += 1
            end

            if u.customer?
                customer_count_all += 1
            elsif u.moderator?
                moderator_count_all += 1
            elsif u.master?
                master_count_all += 1
            end
        end 

        last_new_user = User.last.created_at if User.last

        users = {
            count_all: User.count,
            last_new: last_new_user,
            count_since: user_signups_since,
        }

        roles = {  
            master_count_all: master_count_all,
            moderator_count_all: moderator_count_all,
            customer_count_all: customer_count_all
        }
        return {users: users, all_roles: roles}
    end
end
