#encoding: utf-8

class SessionsController < ApplicationController

  before_filter :get_contact, only: [:new, :edit]
  before_filter :get_observations, only: [:new, :edit]
  before_filter :get_durations_and_prices, only: [:new, :edit]

  # GET /sessions/new
  # GET /sessions/new.json
  def new
    serie = Serie.find(params[:serie_id])
    @session = serie.sessions.new
    @contact = serie.contact
    @path = serie_sessions_path(serie.id)
  end

  # GET /sessions/1/edit
  def edit
    @session = Session.find(params[:id])
    @contact = @session.serie.contact
    @path = serie_session_url(@session.serie, @session.id)
  end

  # POST /sessions
  # POST /sessions.json
  def create

    @session = Session.new(params[:session])
    if @session.save
      flash[:success] = I18n.t('sessions.successfully_created')
      redirect_to contact_path(@session.serie.contact)
    else
      render 'new'
    end
  end

  # PUT /sessions/1
  # PUT /sessions/1.json
  def update
    @session = Session.find(params[:id])
    if @session.update_attributes(params[:session])
      flash[:success] = I18n.t('sessions.successfully_updated')
      redirect_to contact_path(@session.serie.contact)
    else
      render "edit"
    end
  end

  # DELETE /sessions/1
  # DELETE /sessions/1.json
  def destroy
    @session = Session.find(params[:id])
    if @session.deletable? && @session.destroy
      flash[:success] = I18n.t('sessions.successfully_deleted')
    else
      flash[:danger] = "Impossible de supprimer une session qui se trouve dans une facture finalisée!"
    end
    redirect_to contact_url(@session.serie.contact)
  end

  private

    def get_contact
      @contact = if params[:serie_id]
        Serie.find(params[:serie_id])
      elsif params[:id]
        Session.find(params[:id]).serie
      end.contact
    end

    def get_observations
      @observations = Session.observations.map { |observation| [observation, observation] }
      @observations << ["Autre...", ""]
    end

    def get_durations_and_prices
      @durations_prices = Session.durations.map do |duration|
        price = @contact.price_from_duration(duration)
        price_label = price.blank? ? duration : price
        [duration, price_label]
      end
      @durations_prices << ["Autre...", ""]
    end

end
