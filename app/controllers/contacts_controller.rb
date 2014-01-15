class ContactsController < ApplicationController

	def index
		@contacts = Contact.all
	end

	def new
		@contact = Contact.new
	end

	def create
		contact = Contact.new(contact_params)
		if contact.save
			redirect_to :back
		end
	end

	respond_to :html, :json
	def destroy_contacts
		if params[:selected_contact_ids].present?
			params[:selected_contact_ids].each do |contact_id|
				if contact_id.to_i != 0
					@contact = Contact.find(contact_id)
					@org_id = @contact.group.organization_id
					@contact.destroy
				end
			end
			@org = Organization.find(@org_id)
		else
			@org = Organization.find(params[:contact][:org_id])
			@contacts = Contact.find(params[:contact_ids])
		    @contacts.each do |contact|
	  		  @contact.destroy 
	 		end
		end
		respond_with @org
	end

	respond_to :html, :json
	def update
		@contact = Contact.find(params[:id])
		@contact.update_attributes(contact_params)
		respond_with @contact
	end

	private
	def contact_params
		params.require(:contact).permit(Contact.column_names.select { |v| v =~ /[f]/ }.append("group_id"))
	end

end
