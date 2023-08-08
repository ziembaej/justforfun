class Comment < ApplicationRecord
  include Visible

  belongs_to :article

  VALID_STATUSES = ['public', 'private', 'archived']

  validates :status, inclusion: { in: VALID_STATUSES}

  def arvhived?
    status == 'archived'
  end
end
