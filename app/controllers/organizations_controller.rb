class OrganizationsController < ApplicationController

	def index
		@orgs = Organization.all
	end

	def new
		@organization = Organization.new
	end

	def create
		org = Organization.new(org_params)
		# group = org.groups.new(:name=>org.name,:organization_id => org.id)
		binding.pry
		if org.save
			redirect_to organizations_path
		end
	end

	def show
		@org = Organization.find(params[:id])
		if params[:search_field]	
			@contacts = @org.contacts.search(params[:search_field])
		else
			@contacts = @org.contacts
		end
	end

	def create_fields
		field = OrgField.new(fields_params)
		if field.save!
			redirect_to organization_path(params[:organization_id])
		end
	end

	private
	def org_params
		params.require(:organization).permit(:name)
	end

	def fields_params
		params.require(:org_fields).permit(:name,:field_no,:organization_id,:data_type)
	end

end

