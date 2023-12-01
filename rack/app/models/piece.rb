class Piece < ApplicationRecord
    include Visible
    has_many :comments, dependent: :destroy

    #validates :title, presence: true
    #validates :body, presence: true, length: { minimum: 10 }
    validates :brand, presence: true
    validates :model, presence: true

    VALID_STATUSES = ['public', 'private', 'archived']

    validates :status, inclusion: { in: VALID_STATUSES}

    def archived?
        status == 'archived'
    end
end
