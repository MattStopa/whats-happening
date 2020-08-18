<drop-select>
  <div class="btn sort-button">
    <i class="fas {opts.buttonIcon}" if={opts.buttonIcon}></i>
    <span class="xs:hidden">{opts.buttonText}</span>
    <div class='options'>
      <div each={key,value in opts.items} onclick="{selected}" class={ parent.opts.select == value ? 'selected' : ''} data-type={value}>{key}</div>
    </div>
  </div>

  <script>
    let self = this;

    this.selected = function(e){ 
      self.opts.onSelected(e.target.getAttribute('data-type'))
    }
  </script>
</drop-select>