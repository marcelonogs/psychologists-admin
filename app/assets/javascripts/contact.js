function addNationalityField() {

  if (typeof i === 'undefined') i = 1;
  $('#nationalities_div').append("<div id=\"nationality_" + i + "\"><input class=\"text_field\" id=\"contact_nationalities_" + i + "\" name=\"contact[nationalities][" + i + "]]\" type=\"text\"><a href=\"#\"> <i class=\"icon-minus\" onClick=\"deleteNationalityField(" + i + ");\"></i></a></div>");
  $('#contact_nationalities_' + i).focus();
  i++;
}

function deleteNationalityField(j) {
  $('#nationality_' + j).remove();
  i--;
}

function addLanguageField() {

  if (typeof k === 'undefined') k = 1;
  $('#languages_div').append("<div id=\"language_" + k + "\"><input class=\"text_field\" id=\"contact_languages_" + k + "\" name=\"contact[languages][" + k + "]]\" type=\"text\"><a href=\"#\"> <i class=\"icon-minus\" onClick=\"deleteLanguageField(" + k + ");\"></i></a></div>");
  $('#contact_languages_' + k).focus();
  k++;
}

function deleteLanguageField(j) {
  $('#language_' + j).remove();
  k--;
}