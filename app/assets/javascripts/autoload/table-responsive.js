$(document).on("page:change", function () {
  $('body').on('show.bs.dropdown', '.table-responsive', function () {
    $(this).css("overflow", "visible");
  }).on('hide.bs.dropdown', '.table-responsive', function () {
    $(this).css("overflow", "auto");
  });

  $('.wrapper').on('show.bs.dropdown', '.table-responsive', function () {
    $(this).css("overflow", "visible");
  }).on('hide.bs.dropdown', '.table-responsive', function () {
    $(this).css("overflow", "auto");
  });
});