<main-view>
  <style>
    .page-header {
      height: 48px;
      width: 100%;
      background-color: #576875;
      margin-bottom: 10px;
      padding-top: 20px;
      border-bottom: 5px solid #adddff;
    }

    .logo {
      color: #fff;
      margin-top: -24px;
      margin-left: 400px;
      font-size: 39px;
      font-family: Impact;
      letter-spacing: 1px;
    }

    .search-box {
      margin-top: -13px;
      display: inline-block;
      vertical-align: center;
      width: 700px;
      font-size: 27px;
      margin-left: 39px;
      border-radius: 5px;
      background: #ffffff;
      padding: 3px;
      padding-left: 21px;
      margin-bottom: 9px;
      color: #72bcea;
    }

    .add-button{ 
      display: inline-block;
      font-family: "Open Sans";
      font-size: 17px;
      background: #91bfdd;
      padding: 6px 8px;
      border-radius: 4px;
      font-weight: 500;
      margin-top: 1px;
      cursor: pointer;
      color: #fff;
      margin-bottom: 11px;
    }

    .add-button:first-child { 
      margin-left: 19px;
    }
    .main-box {
      padding: 10px 20px;
      max-width: 1000px;
      margin: auto;
    }

    li {
      list-style-type: none;
      margin-bottom: 6px;
      background: #ffffff;
      padding: 5px;
      border-radius: 4px;
      cursor: pointer;
      color: #b73232;
    }

    li:hover { 
      background: #f5eebb
    }

    .bucket-panel { 
      width: 95%;
      height: 400px;
      background: #ea7e54;
      float: right;
      color: #fff;
      margin-right: 12px;
      border-radius: 6px;
      background: #576774e8;
    }
    
    ul { 
      padding: 0px;
      margin: 0px;
      padding: 9px 15px;
    }

    .add-form { 
      position: fixed;
      top: 87px;
      background: #fff;
      margin: auto;
      width: 656px;
    }

    .mini-stats-panel {


      padding-top: 0px;
      border: 1px solid #d6d6d6;
      margin-bottom: 9px;
      margin-right: 10px;
      text-align: center;
      background: #fbfbfb;
    }

    .quick-stats-body { 
      display: flex;
      justify-content: space-between; 
      padding: 20px 10px;
    }

    .quick-stats { 
      margin-bottom: 10px;
      background: #ffa603;
      color: #fff;
      padding: 7px 0px;
      font-weight: 800;
    }

  </style>

    <div class="page-header">
      <div class='logo'>
        <span style="color:#c0d1ff; font-size: 50px">D</span>id     
        <span style="color:#c0d1ff; font-size: 50px">D</span>one     
        <span style="color:#c0d1ff; font-size: 50px">I</span>t     
      </div>

    </div>
    <div>
      <div class='main-box' style="display: flex;   align-items: stretch;">
        <div style="flex-grow: 1; float:right">

          <div class="mini-stats-panel">
            <div class='quick-stats'>Quick Stats</div>
            <div div class="quick-stats-body">
              <div>Completed</div>
              <div>{taskStats.finished} of {taskStats.open + taskStats.finished}</div>
              <div>{taskStats.percentage}%</div>
            </div>
          </div>
          <div class="bucket-panel">
            <ul>
              <li each="{bucket in this.buckets}" onclick="{setBucket}">
                <div >
                  <i class="fas fa-fill" aria-hidden="true"></i>{bucket.name}
                </div>
              </li>
          </div>
        </div>
        <div style="flex-grow: 4">
          <div >
            <div class="add-button" onclick={createEvent}><i class="fas fa-plus-circle"></i> Add Event</div>
            <div style="float: right">
              {view}
              <div class="add-button" onclick={setView('tasks')}><i class="fas fa-list"></i> Tasks</div>
              <div class="add-button" onclick={setView('logs')}><i class="fas fa-book-open"></i> Logs</div>
            </div>
          </div>
          <div>
            <div if={view == "tasks"}>
              <event-list bucket={self.selectedBucket} class="flex-1"></event-list> 
              <div if={showEditor} class='add-form'> 
                  <event-form bucket={self.selectedBucket} class="flex-1"><event-form> 
              </div>
            </div>
            <div if={view == "logs"}>
              <event-logs bucket={self.selectedBucket} class="flex-1"></event-logs>
            </div>
          <div>
        </div>
      </div>
    </div>

  <script>
    this.showEditor = false
    self = this
    tag = ''
    this.buckets = []
    this.taskStats = {}
    this.view = 'tasks'

    this.on('mount', function() {
      new BucketService().index(function(json) { 
        self.buckets = json
        self.selectedBucket = json[0] 
        self.update()
      })
    })

    this.setView = function(name) {
      return function() { 
        self.view = name
        self.update()
      }
    }

    xObserve.listen('bucketResults', function(tasks) {
      self.taskStats.finished = 0
      self.taskStats.open = 0
      tasks.forEach(function(item){ 
        (item.status == 'done') ? self.taskStats.finished++ : self.taskStats.open++
      })

      self.taskStats.percentage = parseInt((( self.taskStats.finished / (self.taskStats.open + self.taskStats.finished) ) ) * 100)
      self.update()
    })

    setTimeout( function(){ 
      route.start(true)
      var routes = route.create()
      routes('/topic/*', function(tag) {
        xObserve.trigger('tagChanged', tag)
      })
    }, 1000)

    setBucket(e) { 
      this.selectedBucket = e.item.bucket
    }

    xObserve.listen('editorClosed', function(event) { 
      self.showEditor = false
      self.update()
    })

    xObserve.listen('editSelected', function(event) { 
      self.showEditor = true
      self.update()
    })

    createEvent() { 
      self.showEditor = true
      xObserve.trigger('createEvent')
    }

  </script>
</main-view>