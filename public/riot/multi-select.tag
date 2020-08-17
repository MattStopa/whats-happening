<multi-select>
  <div class="add-button filter-button">
    <i class="fas {opts.buttonIcon}" if={opts.buttonIcon}></i>
    {opts.buttonText}

    <div class='options'>
      <div each={key, value in opts.items} onclick={selected} data-type={value}>
        <i class="far {key ? 'fa-check-square' : 'fa-square'}"></i>
        {value}
      </div>
      <!--  <div onclick={filter} data-type="partial">
        <i class="far {filters.partial ? 'fa-check-square' : 'fa-square'}"></i>
        Partial
      </div>  -->
    </div>
  </div>

  <script>
    let self = this;
    this.selected = function(e) { 
      self.opts.onSelected(e.target.getAttribute('data-type'))
    }

    
  </script>
</multi-select>