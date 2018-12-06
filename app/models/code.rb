class Code < ApplicationRecord
    # Roles assigned to the keys
    enum role: { master: 0, moderator: 1, customer: 2 }
end
