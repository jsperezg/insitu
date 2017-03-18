var Vats = {};

Vats.findDefaultVat = function (lambda) {
  $.ajax('/api/v1/vats.json').complete(function (response) {
    var vats = response.responseJSON.vats,
        i,
        l = vats.length;

    for (i = 0; i < l; i += 1) {
      if (vats[i].default) {
        lambda(vats[i]);
      }
    }
  });
};