<stats-panel>
  <div class="mini-stats-panel" if={this.taskStats}>
    <div class="quick-stats-body">
      <div class="tab">
        <div class="headline">Done</div>
        <div class="text green">{this.taskStats.finished}</div>
      </div>
      <div class="tab blue">
        <div class="headline blue">Open</div>
        <div class="text blue">{this.taskStats.open}</div>
      </div>
      <div class="tab orange">
        <div class="headline orange">Partial</div>
        <div class="text orange">2</div>
      </div>
    </div>
  </div>

  <script>
    this.taskStats = {}  
    let self = this

    this.on('updated', function() {
      self.taskStats = this.opts.stats
    })

  
  </script>
</stats-panel>