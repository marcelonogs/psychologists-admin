class ChangeBirthdayToActualBirthdates < ActiveRecord::Migration
  def up

  	 limit_year = 2014

  	 contacts = Contact.all

  	 contacts.each do |c|
	  	 begin
	  	 	current_date = Date.strptime(c.birthdate, "%d.%m.%Y")

	  	 	if current_date.year > limit_year
	  	 		c.birthdate = (current_date - 100.year).strftime("%d.%m.%Y")
	  	 		c.save!
	  	 	end
	  	 rescue Exception => e
	  	 end
  	 end

  end

  def down
  	
  end
end
