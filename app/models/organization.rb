class Organization < ActiveRecord::Base
	has_many :groups
	has_many :org_fields
	has_many :contacts, through: :groups
end
