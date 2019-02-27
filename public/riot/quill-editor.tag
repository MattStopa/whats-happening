<quill-editor>
  <style>
    .quill-edit img {
      //object-fit: inherit;
      //width: 100% !important;
      object-fit: scale-down;
      max-width: 100% !important;
      max-height: 300px;
    }
  </style>

  <div class="quill-edit {klass}">
  </div>

  <script>
    let self = this;
    this.klass = "a" + Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);


    this.on('mount', function() { 
      setTimeout(function() { 
        options = {
          readOnly: true,
          debug: false
        }
        self.quill = new Quill('.' + self.klass, options); 

        self.quill.setContents(opts.contents)
      },100)
    })
  </script>
</quill-editor>