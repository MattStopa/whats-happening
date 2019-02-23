<quill-editor>
  <style>
    .quill-edit img {
      max-width: 350px;
    }
  </style>

    <div class="quill-edit {klass}">
    </div>
  <script>
    let self = this;
    this.klass = "a" + Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
;

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