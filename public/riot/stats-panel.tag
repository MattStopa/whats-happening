<stats-panel>
  <div class="mini-stats-panel" if={this.taskStats}>


    <div class='progress-bar mb-4'>
      <div class="progress-display"></div>
    </div>

    <div class="quick-stats-body">
      <div class="tab blue">
        <div class="headline blue">Partial</div>
        <div class="text blue">2</div>
      </div>
      <div class="tab orange">
        <div class="headline orange">Open</div>
        <div class="text orange">{this.taskStats.open}</div>
      </div>
       <div class="tab">
        <div class="headline">Done</div>
        <div class="text green">{this.taskStats.finished}</div>
      </div>
    </div>
  </div>

  <script>
    this.taskStats = {}  
    let self = this

    this.on('updated', function() {
      self.taskStats = this.opts.stats
      self.calcProgressBarSize()
    })

    calcProgressBarSize() {
     let percent =  (this.taskStats.finished / (this.taskStats.open + this.taskStats.finished) ) * 100
     document.getElementsByClassName("progress-display")[0].style.width = percent+ "%"
    }

  </script>
</stats-panel>