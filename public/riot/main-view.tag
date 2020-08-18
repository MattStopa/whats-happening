<main-view>
    <div class="page-header py-1">
      <div class='logo ml-3 text-4xl tracking-wide flex'>
        <div><i class="fas fa-bars sm:hidden"></i></div>
        <div class="ml-5">Task Man.</div>
      </div>
    </div>
    <div>
      <div class="flex bg-white main-box lg:mx-8 p-3 md:mx-0 ">
        <div class="w-56 min-14 xs:hidden">
          <stats-panel stats={taskStats}></stats-panel>
          <bucket-selector buckets={this.buckets} onSelected="{setBucket}"></bucket-selector>
        </div>
        <div class="w-full">
          <div class="flex justify-between">
            <div class="xs:half">
              <button class="btn" onclick={createEvent}><i class="fas fa-plus-circle"></i><span class="xs:hidden">Add Event</span></button>
              <div if={view == 'tasks'} class='inline-block'>
                <drop-select select={this.sortType} items={sorterOptions} on-selected="{sort}" button-text="Sort" button-icon="fa-list"></drop-select>
                <multi-select select={this.sortType} items={filters} on-selected="{filter}" button-text="Filter" button-icon="fa-list"></multi-select>
              </div>
            </div>
            <div class="xs:half">
              <button class="btn" onclick={setView('tasks')}><i class="fas fa-list"></i>Tasks</button>
              <button class="btn" onclick={setView('logs')}><i class="fas fa-book-open"></i>Logs</button>
              <button class="btn" onclick={setView('charts')}><i class="fas fa-book-open"></i>Charts</button>
            </div>
          </div>
          <view-switcher view={view} show-editor={showEditor} bucket={selectedBucket}></view-switcher>
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

    xObserve.listen('bucketResults', 'main-view', function(tasks) {
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

    xObserve.listen('editorClosed', 'main-view', function(event) { 
      self.showEditor = false
      self.update()
    })

    xObserve.listen('editSelected', 'main-view', function(event) { 
      self.showEditor = true
      self.update()
    })

    createEvent() { 
      self.showEditor = true
      xObserve.trigger('createEvent')
    }

  </script>
</main-view>