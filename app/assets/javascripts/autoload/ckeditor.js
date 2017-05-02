(function(){
  'use strict';

  function enableCKEditor() {
    var editor = $('.ckeditoritem');
    if (editor.length) {
      editor.ckeditor({
        title: false,
        toolbarGroups: [
          { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
          { name: 'paragraph',   groups: [ 'list', 'indent', 'align' ] },
          { name: 'styles' }
        ]
      })
    }
  }

  document.addEventListener("turbolinks:load", function() {
    enableCKEditor();
  });
})();
