class Organization < ActiveRecord::Base
	has_many :groups, dependent: :destroy
	has_many :org_fields, dependent: :destroy
	has_many :contacts, through: :groups, dependent: :destroy
end
