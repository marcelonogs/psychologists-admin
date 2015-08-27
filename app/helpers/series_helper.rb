module SeriesHelper
	def contact_name(id)
	    contact = Contact.find_by_id(id)
	    if contact.blank? 
	    	"NO CONTACT ASSIGNED"
	    else
	    	"#{contact.firstname} #{contact.lastname}"
	    end
	end

	def display_delete_link(serie_id)
		serie = Serie.find_by_id(serie_id)

		if serie.sessions.count == 0
			return "<a href=\"#{serie_path(serie)}\" class=\"btn btn-mini btn-danger\" data-confirm=\"#{I18n.t('series.are_you_sure')}\" data-method=\"delete\" rel=\"nofollow\"><i class=\"icon-trash\"></i></a>".html_safe
		end
	end
end
