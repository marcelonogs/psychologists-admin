#encoding: utf-8

class ContactsController < ApplicationController

  before_filter :get_contact_selects, only: [:new, :edit]
  before_filter :get_nationalities_and_languages, only: [:create, :update]

  # GET /contacts
  # GET /contacts.json
  def index

    if params["filter"].present?
      @is_filter_present = true
      @filter = params[:filter].html_safe

      # HOTFIX: We cannot get the number of contacts returned by this search and THEN paginate.
      # I just do the query twice: once for the number of contacts retrieved and another for display.
      @nb_contacts = (Contact.search params[:filter], fields: [{lastname: :word_start, firstname: :word_start}], partial: true).count
      @contacts = Contact.search params[:filter], fields: [{lastname: :word_start}, {firstname: :word_start}],
        partial: true, page: params[:page], per_page: 10, order: {lastname: :asc}
    else
      @bureau_selected = params["bureau"]
      @contacts = case @bureau_selected

        when "geneva"
          Contact.where(bureau: "geneva", is_archived: false)
        when "nyon"
          Contact.where(bureau: "nyon", is_archived: false)
        when "archived"
          Contact.where(is_archived: true)
        else
          @bureau_selected = "all"
          Contact
      end

      @nb_contacts = @contacts.count

      @contacts = @contacts.page(params[:page]).per(10)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @contacts }
    end
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show

    @contact                    = Contact.find(params[:id])
    @series                     = @contact.series.default_order
    @bills                      = @contact.bills.default_order.page(params[:page_bills]).per(8)

    # Sessions partial properties
    @is_editable                = true

    # We select a serie by default.
    params[:serie_id]           = @contact.series.default_order.first.id if params[:serie_id].blank?

    # Get all the sessions or specifically for a given serie_id
    if params[:serie_id] == "all"
      @is_all                   = true
      @sessions                 = Session.where(serie_id: @series.pluck(:id)).default_order
      @serie_name               = "All series"
    else
      @serie_id = params[:serie_id]
      @serie = Serie.find_by_id(@serie_id)
      @serie_name = @serie.name
      @new_session_path = new_serie_session_path(serie_id: @serie_id)
      @sessions = @serie.sessions.default_order.page(params[:page]).per(8)
      @display_all_series_link  = @series.count > 1 && @serie_name.present? && @serie_name != "All series"
      @series.reject! { |serie| serie.name == @serie_name }
    end

    @next_contact = @contact.next
    @previous_contact = @contact.prev

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @contact }
    end
  end

  # GET /contacts/new
  # GET /contacts/new.json
  def new
    @contact = Contact.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @contact }
    end
  end

  # GET /contacts/1/edit
  def edit
    @contact               = Contact.find(params[:id])
    @selected_civil_status = @contact.civil_status

    @nationalities         = @contact.nationalities.sort
    @languages             = @contact.languages.sort

    @first_nationality     = @nationalities.shift.name if @nationalities.present?
    @first_language        = @languages.shift.name     if @languages.present?

  end

  # POST /contacts
  # POST /contacts.json
  def create

    @contact = Contact.new(params[:contact])

    respond_to do |format|

      if @contact.save
        @languages.each { |l| @contact.languages.create name: l }
        @nationalities.each { |n| @contact.nationalities.create name: n }

        format.html { redirect_to @contact, notice: I18n.t('contacts.successfully_created') }
        format.json { render json: @contact, status: :created, location: @contact }
      else
        format.html { render action: "new" }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /contacts/1
  # PUT /contacts/1.json
  def update

    @contact = Contact.find(params[:id])

    beforehand = @contact.is_bill_every_month
    beforehand2 = @contact.bill_every_x_sessions

    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        @contact.languages.delete_all
        @contact.nationalities.delete_all
        @languages.each { |l| @contact.languages.create name: l }
        @nationalities.each { |n| @contact.nationalities.create name: n }

        # Change the session collecting policy if necessary.
        if @contact.is_bill_every_month != beforehand || beforehand2 != @contact.bill_every_x_sessions
          change_session_organization_strategy_for(@contact.id)
        end

        format.html { redirect_to @contact, notice: I18n.t('contacts.successfully_updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy

    @contact = Contact.find(params[:id])
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to contacts_url, notice: I18n.t('contacts.successfully_deleted') }
      format.json { head :no_content }
    end
  end

  private

    def get_contact_selects
      @titles         = Contact::TITLES.map { |title| [title, title] }
      @billing_titles = (Contact::TITLES - ["Votre Fils,", "Votre Fille,"]).map { |title| [title, title] }
      @bureaus        = [["Genève", "geneva"], ["Nyon", "nyon"]]
      @civil_statuses = Contact::CIVIL_STATUSES.map { |cs| [cs, cs] }
    end

    def get_nationalities_and_languages
      @nationalities = []
      params[:contact][:nationalities].each do |k, v|
        @nationalities << v if v.present?
      end

      @languages = []
      params[:contact][:languages].each do |k, v|
        @languages << v if v.present?
      end

      params[:contact].delete :nationalities
      params[:contact].delete :languages
    end

end
