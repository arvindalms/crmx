class Group < ActiveRecord::Base
	belongs_to :organization
	has_many :contacts, dependent: :destroy
end
