class Recipe < ActiveRecord::Base
  attr_accessible :name, :description, :duration
end
