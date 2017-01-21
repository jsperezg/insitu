$(document).ready(function () {
  'use strict';

  var editor = $('.ckeditor');

  if (editor.length) {
    editor.ckeditor({
      title: false
    })
  }
});