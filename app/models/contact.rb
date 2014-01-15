class Contact < ActiveRecord::Base
	belongs_to :group
	
	def self.search(search)
    search_str = []  
    search.each do | single |    
      if ActiveRecord::Base.connection.instance_values["config"][:adapter] == "mysql2"
        search_str << "#{single[0]} LIKE '%#{single[1]}%' " if !single[1].blank?
      else
        search_str << "#{single[0]} ILIKE '%#{single[1]}%' " if !single[1].blank?
      end
    end
    if search
     where(search_str.join(' and '))
    else
     scoped
    end
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names.select { |v| v =~ /[f]/ }.append("group_id")
      all.each do |product|
        csv << product.attributes.values_at(*column_names.select { |v| v =~ /[f]/ }.append("group_id"))
      end
    end
  end




end
