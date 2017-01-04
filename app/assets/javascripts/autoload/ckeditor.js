$(document).ready(function () {
  let editor = $('.ckeditor');

  if (editor.length) {
    editor.ckeditor({
      title: false
    })
  }
});