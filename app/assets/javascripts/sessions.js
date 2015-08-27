$(document).ready(function() {
  // Sets the datepicker.
  $('div#session .datepicker').datepicker({format: "dd.mm.yyyy", language: "fr", autoclose: "true"});

  // Change session duration.

  initDuration();
  $('div#session .select_duration').change(changeSessionDuration);

  // Change observations.
  initObservations();
  $('div#session .select_observations').change(changeObservations);

  // Submits the form.
  $('div#session .session_submit').submit(submitform);
});

function initDuration() {
  if ($('div#session .select_duration').find(':selected').text() == 'Autre...') {
    $('.custom_duration').prop('disabled', false);
  }
}

function initObservations() {
  if ($('div#session .select_observations').find(':selected').text() == 'Autre...') {
    $('.custom_observations').prop('disabled', false);
  }
}

function changeSessionDuration() {
  var selected_duration = $(this).find(':selected');
  var selected_duration_text = selected_duration.text();
  var selected_duration_value = selected_duration.val();

  $('.custom_duration').prop('disabled', true);

  // Custom duration field if needed.
  if (selected_duration_text == 'Autre...') {
    $('.custom_duration').prop('disabled', false);
  }

  // Change value for the price field.
  if (selected_duration_text == "30" || selected_duration_text == "45"
    || selected_duration_text == "1h" || selected_duration_text == "1h30") {
    $('.price').val(selected_duration_value);
  }
}

function changeObservations() {
  var field = $('.custom_observations');

  // Custom observations field if needed.
  field.prop('disabled', true);
  if ($(this).find(':selected').text() == 'Autre...') {
    field.prop('disabled', false);
  }
}

function submitform() {
  // Set observations.
  var observation = $('.select_observations').find(':selected');
  if (observation.text() != 'Autre...') {
    $('.observations').val(observation.val());
  } else {
    $('.observations').val($('.custom_observations').val());
  }

  // Set duration.
  var duration = $('.select_duration').find(':selected');
  if (duration.text() != 'Autre...') {
    $('.duration').val(duration.text());
  } else {
    $('.duration').val($('.custom_duration').val());
  }

  $('#session_submit').submit();
}
