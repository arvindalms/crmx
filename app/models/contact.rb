class Contact < ActiveRecord::Base
	belongs_to :group
	
	def self.search(search)
    search_str = []
    
    search.each do | single |
      
      search_str <<  "#{single[0]} LIKE '%#{single[1]}%' " if !single[1].blank?
    end
    if search
     where(search_str.join(' or '))
    else
     scoped
    end
  end
end
