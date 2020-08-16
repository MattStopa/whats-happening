<drop-select>
  <div class="add-button sort-button">
    <i class="fas {opts.buttonIcon}" if={opts.buttonIcon}></i>
    {opts.buttonText}
    <div class='options'>
      <div each={key,value in opts.items} onclick="{selected}" class={ parent.opts.select == value ? 'selected' : ''} data-type={value}>{key}</div>
    </div>
  </div>

  <script>
    let self = this;

    this.selected = function(e){ 
      self.opts.onSelected(e.target.getAttribute('data-type'))
      console.log(self.opts)
    }
  </script>
</drop-select>