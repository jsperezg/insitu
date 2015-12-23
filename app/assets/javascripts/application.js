// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require turbolinks
//= require best_in_place
//= require jquery-ui
//= require best_in_place.jquery-ui
//= require moment
//= require bootstrap-datetimepicker
//= require_tree ./autoload

if (typeof jQuery !== 'undefined') {
  $(document).on("page:change", function () {
    var bestInPlace = $(".best_in_place");

    if (bestInPlace.length) {
      /* Activating Best In Place */
      bestInPlace.best_in_place();

        jQuery(document).on('best_in_place:error', function (event, request, error) {
          'use strict';
          // Display all error messages from server side validation
          jQuery.each(jQuery.parseJSON(request.responseText), function (index, value) {
            var container = jQuery('#bip_error_message');

            if (typeof value === "object") {value = index + " " + value.toString(); }

            container.html(value);
            container.show();
            window.setTimeout(function() { container.hide(); }, 2000);
          });
        });
    }
  });
}
