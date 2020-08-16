<main-view>
    <div class="page-header">
      <div class='logo'>
        Task Master
      </div>
    </div>
    <div>
      <div class='main-box'>
        <div style="flex: 1;">
          <stats-panel stats={taskStats}></stats-panel>
          <bucket-selector  buckets={this.buckets} onSelected="{setBucket}"></bucket-selector>
        </div>
        <div style="flex: 3">
          <div >
            <div class="add-button" onclick={createEvent}><i class="fas fa-plus-circle"></i>Add Event</div>

            <drop-select select={this.sortType} items={sorterOptions} on-selected="{sort}" button-text="Sort" button-icon="fa-list"></drop-select>
            <multi-select select={this.sortType} items={filters} on-selected="{filter}" button-text="Filter" button-icon="fa-list"></multi-select>
           
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

    this.sorterOptions = {
      "updated_at:desc": "Modified - Newest",
      "updated_at:asc": "Modified - Oldest",
      "created_at:desc": "Created - Newest",
      "created_at:asc": "Created - Oldest"
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

    this.filter = function(name) { 
      let value = self.filters[name]
      self.filters[name] = !value;
      xObserve.trigger('sort', self.storeFilterData())
    }

    this.sort = function(value) {
      self.sortType = value
      xObserve.trigger('sort', self.storeFilterData())
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
      this.update()
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