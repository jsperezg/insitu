$(document).ready(function () {
  'use strict';

  let editor = $('.ckeditor');

  if (editor.length) {
    editor.ckeditor({
      title: false
    })
  }
});