require 'csv'

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
		@organisation = Organization.new
		@org = Organization.find(params[:id])
		@groups = @org.groups

		if params[:search_field]
			@contacts = @org.contacts.search(params[:search_field]).order(:id)
		else
			@contacts = @org.contacts.order(:id)
		end
		respond_to do |format|
	      format.html
	      format.js
	      format.csv { send_data @contacts.to_csv, :type => 'text/csv', :filename => "contacts.csv" }
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

	def new_fields
		if OrgField.find_by_organization_id(params[:organization_id]).nil?
			@count = 0
		else
			@count = OrgField.find_all_by_organization_id(params[:organization_id]).last.field_no.gsub("f", "").to_i
		end
	end

	def create_fields
		if fields_params["field_no"].gsub("f","").to_i > Contact.column_names.keep_if{ |v| v =~ /[f]/ }.count
			system "rails g migration add_column_#{fields_params["field_no"]}_to_contacts #{fields_params["field_no"]}:string"
			system "rake db:migrate"
		end
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

	def upload_csv
		if params[:file].content_type == "text/csv"
		  contacts = []
		  @available_fields = OrgField.find_all_by_organization_id(Group.find(params[:default_group_id]).organization_id).collect(&:field_no)
	      CSV.foreach(params[:file].tempfile) { |row|
	          row = row.first.split(",") if row.count == 1
	          contact_data = {}
	          @available_fields.each_with_index do |field, index|
		          contact_data[field] = row[index]
		      end
	          if(!row.last.blank? && (Group.all.collect(&:id).include? row.last.to_i))
	          	contact_data["group_id"] = row.last
	          else
	          	contact_data["group_id"] = params[:default_group_id]
	          end
	          contacts << contact_data
	      }

	      #remove first row with column name and make a new array with contacts
	      contacts = contacts[1..contacts.length]
	      contacts.each do |contact|
	        @contact = Contact.new
	        @available_fields.each_with_index do |field, index|
	        	@contact[field] = contact[field]
	        end
	        @contact.group_id=contact["group_id"]
	        @contact.save
     	  end
     	  redirect_to organization_path(Group.find(params[:default_group_id]).organization_id)
		else
		  redirect_to organization_path(Group.find(params[:default_group_id]).organization_id)
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

