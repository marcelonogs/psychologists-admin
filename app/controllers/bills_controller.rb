#encoding: utf-8

class BillsController < ApplicationController

  before_filter :get_contact_id

  # GET /bills
  # GET /bills.json
  def index
    @bills = Bill.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bills }
    end
  end

  # GET /bills/1
  # GET /bills/1.json
  def show

    @bill                       = Bill.find(params[:id])

    @sessions                   = @bill.sessions.default_order

    refnum = @bill.reference_number
    @formatted_reference_number = refnum.present? ? "#{refnum[0..refnum.length / 2]} #{refnum[(refnum.length / 2) + 1 .. -1]}" : nil

    if @bill.sessions.count > 6
      flash[:alert] = "Cette facture contient plus de 6 séances, le bulletin de versement ne sera donc pas affiché."
    end

    contact = @bill.contact
    if contact.is_billing_contact
      if contact.billing_title.blank? || contact.billing_firstname.blank? ||
        contact.billing_lastname.blank? || contact.billing_street.blank? ||
        contact.billing_city.blank? || contact.billing_zipcode.blank? || contact.billing_country.blank?
        flash[:alert] = 'Veuillez remplir entête de la facture ou la désactiver.'
        redirect_to contact_path(contact)
        return
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bill }
      format.pdf do
        pdf = InvoicePdf.new(@bill, @bill.id)
        send_data pdf.render, filename:
        "invoice_#{@bill.created_at.strftime("%d/%m/%Y")}.pdf",
        type: "application/pdf",
        disposition: "inline"
      end
    end
  end

  # GET /bills/new
  # GET /bills/new.json
  def new

    get_contact_sessions

    if @sessions.blank?
      redirect_to contact_url(@contact_id), notice: "Aucune séance disponible pour mettre dans une facture..."
      return
    end

    @bill                       = Bill.new
    @path                       = contact_bills_url(@contact_id)
    @cancel_path                = contact_path(@contact_id)

    # Status available for the bill.
    @statuses = []
    Bill::STATUSES.values.each { |status| @statuses << [I18n.t("bills.statuses.#{status}"), status] }

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bill }
    end
  end

  # GET /bills/1/edit
  def edit
    @bill                       = Bill.find(params[:id])
    @edit_mode = true
    preload_edit
  end

  # POST /bills
  # POST /bills.json
  def create

    ############################ Rows filtering ############################

    # If the user did not selected any rows, return.
    if params[:selected_rows].blank?
      redirect_to contact_url(params[:contact_id]), notice: "Vous devez sélectionner des séances pour créer une nouvelle facture!"
      return
    end

    session_ids = []
    params[:selected_rows].split(",").each do |id|
      session = Session.find_by_id(id)
      session_ids << id unless session.in_bill?
    end

    # If the user only selected used rows (in another bill), return.
    if session_ids.blank?
      redirect_to contact_url(params[:contact_id]), notice: "Vous devez sélectionner des séances non-utilisées pour créer une nouvelle facture!"
      return
    end

    ######################### End of Rows filtering ########################

    @bill            = Bill.new(params[:bill])
    @bill.contact_id = params[:contact_id]

    respond_to do |format|

      if @bill.save

        # Adds all the selected sessions to the current bill
        session_ids.each { |id| @bill.sessions << Session.find_by_id(id) }

        format.html { redirect_to contact_bill_url(@bill.contact.id, @bill.id), notice: I18n.t('bills.successfully_created') }
        format.json { render json: @bill, status: :created, location: @bill }
      else
        get_contact_sessions
        if @sessions.blank?
          redirect_to contact_url(@contact_id), notice: "Aucune séance disponible pour mettre dans une facture..."
          return
        end
        @path                       = contact_bills_url(@contact_id)
        @cancel_path                = contact_path(@contact_id)
        format.html { redirect_to @path }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bills/1
  # PUT /bills/1.json
  def update

    ############################ Rows filtering ############################

    # If the user did not selected any rows, return.
    if params[:selected_rows].blank?
      redirect_to contact_url(params[:contact_id]), notice: "Vous devez sélectionner des séances pour créer une nouvelle facture!"
      return
    end

    session_ids = []
    params[:selected_rows].split(",").each do |id|
      session = Session.find_by_id(id)
      # Add it if it's our session or if no one has it.
      session_ids << id if session.in_bill?(params[:id].to_i) || !session.in_bill?
    end

    # If the user only selected used rows (in another bill), return.
    if session_ids.blank?
      redirect_to contact_url(params[:contact_id]), notice: "Vous devez sélectionner des séances non-utilisées pour créer une nouvelle facture!"
      return
    end

    ######################### End of Rows filtering ########################

    @bill = Bill.find(params[:id])

    respond_to do |format|
      if @bill.update_attributes(params[:bill])

        @bill.sessions.delete_all

        # Adds all the selected sessions to the current bill
        session_ids.each { |id| @bill.sessions << Session.find_by_id(id) }

        format.html { redirect_to contact_bill_url(@bill.contact.id, @bill.id), notice: I18n.t('bills.successfully_updated') }
        format.json { head :no_content }
      else
        preload_edit
        format.html { render action: "edit" }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bills/1
  # DELETE /bills/1.json
  def destroy
    @bill = Bill.find(params[:id])
    @bill.sessions.delete_all
    @bill.destroy

    respond_to do |format|
      format.html { redirect_to contact_url(@contact_id), notice: I18n.t('bills.successfully_deleted') }
      format.json { head :no_content }
    end
  end

  private

    def get_contact_id
      @contact_id = params[:contact_id]
    end

    def preload_edit
      @path                       = contact_bill_url(@contact_id, params[:id])
      @cancel_path                = contact_bill_path(@contact_id, @bill)

      # Status available for the bill.
      @statuses = []
      Bill::STATUSES.values.each { |status| @statuses << [I18n.t("bills.statuses.#{status}"), status] }
      @selected_status = @bill.status

      refnum = @bill.reference_number
      @formatted_reference_number = refnum.present? ? "#{refnum[0..refnum.length / 2]} #{refnum[(refnum.length / 2) + 1 .. -1]}" : nil

      @bill_sent_on = @bill.sent_on.present? ? @bill.sent_on.strftime("%d.%m.%Y") : nil
      @bill_paid_on = @bill.paid_on.present? ? @bill.paid_on.strftime("%d.%m.%Y") : nil
      @bill_recall_sent_on = @bill.recall_sent_on.present? ? @bill.recall_sent_on.strftime("%d.%m.%Y") : nil

      get_contact_sessions

      @selected_sessions          = @bill.sessions.default_order
      @session_nos = {}

      # Instead of @sessions, put @available_sessions
      @sessions.each_with_index do |s, i|
        @session_nos[s] = i if @selected_sessions.include?(s)
      end
    end

    def get_contact_sessions
      # Get all the sessions for this contact
      series      = Serie.default_order.where(contact_id: @contact_id)
      @sessions   = Session.default_order.where(serie_id: series.map(&:id).uniq)
      @sessions   = (@bill.blank? ? @sessions.where("bill_id IS NULL") : @sessions.where("bill_id IS NULL OR bill_id = ?", @bill.id)).default_order
    end

end
