class ApplicationRecord < ActiveRecord::Base
  include Visible
  primary_abstract_class
end
