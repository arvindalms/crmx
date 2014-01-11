class Contact < ActiveRecord::Base
	belongs_to :group
	
	def self.search(search)
    search_str = []  
    search.each do | single |    
      search_str << "#{single[0]} LIKE '%#{single[1]}%' " if !single[1].blank?
    end
    if search
     where(search_str.join(' and '))
    else
     scoped
    end
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << Contact.column_names.select { |v| v =~ /[f]/ || v=~ /g/ }
      all.each do |product|
        csv << product.attributes.values_at("f1", "f2", "f3", "f4", "f5", "f6", "f7", "f8", "f9", "f10", "group_id")
      end
    end
  end


end
