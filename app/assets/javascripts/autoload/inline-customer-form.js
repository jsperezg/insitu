$(document).on('turbolinks:load', function() {
  var inlineCustomerForm = $('#new-customer-inline');

  if (inlineCustomerForm.length) {
    inlineCustomerForm.on('show.bs.modal', function () {
      inlineCustomerForm.find('input[type=text]').each(function () {
        $(this).prop('title', '');
        $(this).parent().removeClass('has-error');
        $(this).val('');
      });
    });

    inlineCustomerForm.on('shown.bs.modal', function () {
      $('#customer_tax_id').focus();
    });

    inlineCustomerForm.on('ajax:success', function (e, data, status, xhr) {
      var customerSelector = $('.customer-selector');

      if (customerSelector.length) {
        customerSelector.find('input[type=text]').val(data.name);
        customerSelector.find('input[type=hidden]').val(data.id);
      }

      $('#create-customer-modal').modal('hide');
    }).on('ajax:error', function (e, xhr, status, error) {
      var attribute, input;

      for (attribute in xhr.responseJSON) {
        if (xhr.responseJSON.hasOwnProperty(attribute)) {
          input = $('#customer_' + attribute);

          if (input.length) {
            input.prop('title', xhr.responseJSON[attribute][0]);
            input.parent().addClass('has-error');
          }
        }
      }
    });
  }
});