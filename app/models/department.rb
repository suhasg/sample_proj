class Department < ActiveRecord::Base
  validates :name, length: {minimum: 3}, presence: true
end
