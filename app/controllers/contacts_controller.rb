class ContactsController < ApplicationController

	def index
			@contacts = Contact.all
	end

	def new
		@contact = Contact.new
	end

	def create
		contact = Contact.new(contact_params)
		contact.save
		redirect_to :back
	end

	private
	def contact_params
		params.require(:contact).permit(:group_id,:f1,:f2,:f3,:f4,:f5,:f6,:f7,:f8,:f9,:f10)
	end

end
