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
			@contacts = []
			if params[:search_field].values.uniq.count == 1 
				if params[:search_field].values.uniq.first.blank?
					@contacts = @org.contacts.sort_by(&:id)
				else
					params[:search_field].each do |key, value|
						if ActiveRecord::Base.connection.instance_values["config"][:adapter] == "mysql2"
							@contacts += @org.contacts.find(:all, :conditions => ["#{key} like lower(?)", "%#{value}%"]).sort_by(&:id) if !value.blank?
						else
							@contacts += @org.contacts.find(:all, :conditions => ["#{key} ilike lower(?)", "%#{value}%"]).sort_by(&:id) if !value.blank?
						end
					end
				end
		  else
				params[:search_field].each do |key, value|
					if ActiveRecord::Base.connection.instance_values["config"][:adapter] == "mysql2"
							@contacts += @org.contacts.find(:all, :conditions => ["#{key} like lower(?)", "%#{value}%"]).sort_by(&:id) if !value.blank?
					else
						@contacts += @org.contacts.find(:all, :conditions => ["#{key} ilike lower(?)", "%#{value}%"]).sort_by(&:id) if !value.blank?
					end
				end
			end
		else
			@contacts = @org.contacts.sort_by(&:id)
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

	def upload_csv
		if params[:file].content_type == "text/csv"
		  contacts = []
	      CSV.foreach(params[:file].tempfile) { |row|
	          row = row.first.split(",") if row.count == 1
	          contact_data = {}
	          contact_data["f1"] = row[0]
	          contact_data["f2"] = row[1]
	          contact_data["f3"] = row[2]
	          contact_data["f4"] = row[3]
	          contact_data["f5"] = row[4]
	          contact_data["f6"] = row[5]
	          contact_data["f7"] = row[6]
	          contact_data["f8"] = row[7]
	          contact_data["f9"] = row[8]
	          contact_data["f10"] = row[9]

	          if(!row[10].blank? && (Group.all.collect(&:id).include? row[10].to_i))
	          	contact_data["group_id"] = row[10]
	          else
	          	contact_data["group_id"] = params[:default_group_id]
	          end
	          contacts << contact_data
	      }

	      #remove first row with column name and make a new array with contacts
	      contacts = contacts[1..contacts.length]
	      contacts.each do |contact|
	        @contact = Contact.new
	        @contact.f1=contact["f1"]
	        @contact.f2=contact["f2"]
	        @contact.f3=contact["f3"]
	        @contact.f4=contact["f4"]
	        @contact.f5=contact["f5"]
	        @contact.f6=contact["f6"]
	        @contact.f7=contact["f7"]
	        @contact.f8=contact["f8"]
	        @contact.f9=contact["f9"]
	        @contact.f10=contact["f10"]
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

