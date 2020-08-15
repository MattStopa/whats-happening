<main-view>
  <style>
    .page-header {
      height: 48px;
      width: 100%;
      background-color: #f9f5ea;
      margin-bottom: 10px;
      padding-top: 14px;
    }

    .logo {
      color: #fff;
      margin-left: 54px;
      font-size: 39px;
      font-family: Impact;
      letter-spacing: 1px;
      color: #565656;
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
      font-size: 15px;
      background: #f3f2f2;
      padding: 6px 8px;
      border-radius: 4px;
      font-weight: 500;
      margin-top: 1px;
      cursor: pointer;
      color: #5a5a5a;
      margin-bottom: 11px;
      border: 1px solid #d0d0d0;
    }

    .add-button i {
      margin-right: 5px;
    }

    .add-button:first-child { 
      margin-left: 19px;
    }
    .main-box {
      display: flex;
      align-items: stretch;
      background: #fff;
      margin: 0px 29px;
      display: flex;   
      align-items: stretch;
      padding: 11px;
      border: 1px solid #d8d8d8;
      border-radius: 4px;
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
      padding-top: 7px;
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
      margin-right: 10px;
      text-align: center;
      margin-bottom: 5px;
    }

    .mini-stats-panel .headline {
      background: #42b253;
      color: #fff;
      padding: 2px;
      font-size: 14px;
      font-weight: 700;
    }

    .mini-stats-panel .headline.blue {
      background: #4772de;
    }

    .mini-stats-panel .headline.orange {
      background: #ffaa00;
    }

    .mini-stats-panel .tab {
      border: 1px solid #42b253;
      border-radius: 6px;
      flex: 1;
      margin-right: 3px;
    }

    .mini-stats-panel .tab.blue {
      border: 1px solid #4772de;
    }

    .mini-stats-panel .tab.orange {
      border: 1px solid #ffaa00;
    }

    .mini-stats-panel .tab .text {
      font-size: 33px;
      font-weight: 800;
    }

    .mini-stats-panel .tab .text.green {
      color: #42b253;
    }

    .mini-stats-panel .tab .text.orange {
      color: #ffaa00;
    }

    .mini-stats-panel .tab .text.blue {
      color: #4772de;
    }

    .quick-stats-body { 
      display: flex;
      justify-content: space-between; 
    }

    .quick-stats { 
      margin-bottom: 10px;
      background: #ffa603;
      color: #fff;
      padding: 7px 0px;
      font-weight: 800;
    }

    .sort-button:hover .options {
      display: block;
      position: absolute;
      background: #fafafa;
      padding: 9px;
      margin-top: 7px;
      margin-left: -8px;
      border-radius: 3px;
      border: 1px solid #d1d1d1;
    }

    .sort-button .options {
      display: none;
    }

    .sort-button .options div {
      padding: 5px 10px;
      border-radius: 3px;
    }

    .sort-button .options div:hover {
      background: #7da6c1;
    }

    .sort-button .options div.selected{
      background: #4772de;
      color: #fff;
    }

    .filter-button:hover .options {
      display: block;
      position: absolute;
      background: #fafafa;
      padding: 9px;
      margin-top: 7px;
      margin-left: -8px;
      border-radius: 3px;
      border: 1px solid #d1d1d1;
    }


    .filter-button .options {
      display: none;
    }

    .filter-button .options div {
      padding: 5px 10px;
      border-radius: 3px;
    }

    .filter-button .options div:hover {
      background: #7da6c1;
    }

    .filter-button .options div.selected{
      padding: 5px 10px;
      border-radius: 3px;
    }

    .filter-button i {
      margin-right: 8px;  
    }


  </style>

    <div class="page-header">
      <div class='logo'>
        Task Master
      </div>

    </div>
    <div>
      <div class='main-box'>
        <div style="flex: 1;">

          <div class="mini-stats-panel">
            <div div class="quick-stats-body">
              <div class="tab">
                <div class="headline">Done</div>
                <div class="text green">{taskStats.finished}</div>
              </div>
              <div class="tab blue">
                <div class="headline blue">Open</div>
                <div class="text blue">{taskStats.open}</div>
              </div>
              <div class="tab orange">
                <div class="headline orange">Partial</div>
                <div class="text orange">2</div>
              </div>
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
        <div style="flex: 3">
          <div >
            <div class="add-button" onclick={createEvent}><i class="fas fa-plus-circle"></i>Add Event</div>

            <div class="add-button sort-button">
              <i class="fas fa-list"></i>
              Sort
              <div class='options'>
                <div onclick={sort} class={ sortType == "updated_at:desc" ? 'selected' : ''} data-type="updated_at:desc">Modified - Newest</div>
                <div onclick={sort} class={ sortType == "updated_at:asc" ? 'selected' : ''} data-type="updated_at:asc">Modified - Oldest</div>
                <div onclick={sort} class={ sortType == "created_at:desc" ? 'selected' : ''} data-type="created_at:desc">Created - Newest</div>
                <div onclick={sort} class={ sortType == "created_at:asc" ? 'selected' : ''} data-type="created_at:asc">Created - Oldest</div>
              </div>
            </div>

            <div class="add-button filter-button" onclick={sortLatest}>
              <i class="fas fa-list"></i>
              Filter

              <div class='options'>
                <div onclick={filter} data-type="finished">
                  <i class="far {filters.finished ? 'fa-check-square' : 'fa-square'}"></i>
                  Finished
                </div>
                <div onclick={filter} data-type="open">
                  <i class="far {filters.open ? 'fa-check-square' : 'fa-square'}"></i>
                  Open
                </div>
                <!--  <div onclick={filter} data-type="partial">
                  <i class="far {filters.partial ? 'fa-check-square' : 'fa-square'}"></i>
                  Partial
                </div>  -->
              </div>
            </div>
            <div style="float: right">
              {view}
              <div class="add-button" onclick={setView('tasks')}><i class="fas fa-list"></i>Tasks</div>
              <div class="add-button" onclick={setView('logs')}><i class="fas fa-book-open"></i>Logs</div>
              <div class="add-button" onclick={setView('charts')}><i class="fas fa-book-open"></i>Charts</div>
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
            <div if={view == "charts"}>
              <chart-view bucket={self.selectedBucket} class="flex-1"></chart-view>
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
    this.sortType = "updated_at:asc" 
    this.filters = {
      finished: true,
      open: true,
      partial: true
    }

    this.on('mount', function() {
      new BucketService().index(function(json) { 
        self.buckets = json
        self.selectedBucket = json[0] 
        self.update()
      })
      if(localStorage.getItem("filterAndSort") == null)  {
        this.sortType = "updated_at:asc" 
        this.storeFilterData() 
      }

    })

    this.setView = function(name) {
      return function() { 
        self.view = name
        console.log(name)
        self.update()
      }
    }

    this.filter = function(x) { 
      let value = self.filters[x.target.getAttribute('data-type')]
      self.filters[x.target.getAttribute('data-type')] = !value;
      xObserve.trigger('sort', this.storeFilterData())
    }

    this.sort = function(x) {
      self.sortType = x.target.getAttribute('data-type')
      xObserve.trigger('sort', this.storeFilterData())
    }

    this.storeFilterData = function() { 
      let data = this.sortType.split(":")
      let values = { 
        sortKey: data[0], 
        direction: data[1],
        filters: self.filters
      }
      localStorage.setItem("filterAndSort", JSON.stringify(values))
      return values;
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