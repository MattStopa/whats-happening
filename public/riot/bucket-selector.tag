<bucket-selector>
  <div class="bucket-panel">
    <ul>
      <li each="{bucket in opts.buckets}" onclick="{setBucket}">
        <div >
          <i class="fas fa-fill" aria-hidden="true"></i>{bucket.name}
        </div>
      </li>
  </div>

  <script>
    let self = this
    setBucket = function(e) {
      self.opts.onselected(e)
    }
  </script>
</bucket-selector>  