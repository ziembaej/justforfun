class Comment < ApplicationRecord
  include Visible

  belongs_to :piece

  VALID_STATUSES = ['public', 'private', 'archived']

  validates :status, inclusion: { in: VALID_STATUSES}

  def arvhived?
    status == 'archived'
  end
end
