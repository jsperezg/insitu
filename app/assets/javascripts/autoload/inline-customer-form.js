$(document).on('turbolinks:load', function() {
  var inlineCustomerForm = $('#new-customer-inline');

  if (inlineCustomerForm.length) {
    inlineCustomerForm.on('ajax:success', function (e, data, status, xhr) {
      var customerSelector = $('.customer-selector');

      if (customerSelector.length) {
        customerSelector.find('input[type=text]').val(data.name);
        customerSelector.find('input[type=hidden]').val(data.id);
      }

      $('#create-customer-modal').modal('hide');
    }).on('ajax:error', function (e, xhr, status, error) {
      //TODO Deal with errors.
      console.log(e, xhr, status, error);
    });
  }
});