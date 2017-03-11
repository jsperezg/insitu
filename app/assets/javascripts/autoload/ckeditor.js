(function(){
  'use strict';

  function enableCKEditor() {
    var editor = $('.ckeditor');
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

  $(document).on("turbolinks:load", enableCKEditor);
  $(document).ajaxComplete(enableCKEditor);
})();
