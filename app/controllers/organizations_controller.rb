class OrganizationsController < ApplicationController

	def index
		@orgs = Organization.all
	end

	def new
		@organization = Organization.new
	end

	def create
		org = Organization.new(org_params)
		if org.save
			redirect_to organization_new_group_path(org.id)
		end
	end

	def show
		@org = Organization.find(params[:id])
		@groups = @org.groups
		if params[:search_field]	
			@contacts = @org.contacts.search(params[:search_field])
		else
			@contacts = @org.contacts
		end
	end

	def destroy
		@org = Organization.find(params[:id])
		@org.destroy
		redirect_to root_path
	end

	def groups
		@org = Organization.find(params[:organization_id])
		@groups = @org.groups
	end

	def create_fields
		field = OrgField.new(fields_params)
		if field.save!
			redirect_to organization_path(params[:organization_id])
		end
	end

	def create_group
		group = Group.new(group_params)
		if group.save
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

	def group_params
		params.require(:group).permit(:name,:organization_id)
	end

end

