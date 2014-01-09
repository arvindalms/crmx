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
		@org = Organization.find(params[:contact][:org_id])
	  contacts = Contact.find(params[:contact_ids])
	  contacts.each do |contact|
	  	contact.destroy 
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
		params.require(:contact).permit(:group_id,:f1,:f2,:f3,:f4,:f5,:f6,:f7,:f8,:f9,:f10)
	end

end
