# encoding: utf-8
module SessionsHelper
  def default_start_date
    (@session.start_date || DateTime.now).strftime("%d.%m.%Y")
  end

  def default_duration_for_select
    if custom_duration?
      ['Autre...', '']
    else
      duration = @session.duration || default_price_wanted
      duration_label = @contact.price_from_duration(duration)
      duration_label.present? ? duration_label : duration
    end
  end

  def set_custom_duration
    @session.duration if custom_duration?
  end

  def default_price
    @session.price || @contact.price_from_duration(default_price_wanted)
  end

  def default_observations_for_select
    if custom_observations?
      ['Autre...', '']
    else
      observations = @session.observations || default_observation_wanted
      [observations, observations]
    end
  end

  def set_custom_observations
    @session.observations if custom_observations?
  end

  private

    def default_price_wanted
      '45'
    end

    def default_observation_wanted
      ["Séance individuelle", "Séance individuelle"]
    end

    def custom_duration?
      @session.duration.present? && !Session.durations.include?(@session.duration)
    end

    def custom_observations?
      @session.observations.present? && !Session.observations.include?(@session.observations)
    end

end
